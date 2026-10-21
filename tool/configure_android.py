#!/usr/bin/env python3
"""Apply ClawdStudio's native Termux bridge to a Flutter-generated Android project."""

from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
ANDROID = ROOT / "android"
MANIFEST = ANDROID / "app" / "src" / "main" / "AndroidManifest.xml"
KOTLIN_ROOT = ANDROID / "app" / "src" / "main" / "kotlin"


def main() -> int:
    if not MANIFEST.is_file() or not KOTLIN_ROOT.is_dir():
        print("Android scaffold missing. Run: flutter create --platforms=android --project-name=clawd_studio --org=dev.clawdstudio .", file=sys.stderr)
        return 2

    activity_paths = list(KOTLIN_ROOT.rglob("MainActivity.kt"))
    if len(activity_paths) != 1:
        print(f"Expected exactly one generated MainActivity.kt, found {len(activity_paths)}", file=sys.stderr)
        return 2

    activity_path = activity_paths[0]
    activity_source = activity_path.read_text(encoding="utf-8")
    package_match = re.search(r"^package\s+([A-Za-z0-9_.]+)", activity_source, re.MULTILINE)
    if not package_match:
        print("Could not determine generated Android Kotlin package.", file=sys.stderr)
        return 2
    package_name = package_match.group(1)

    for template_name, output_name in (
        ("MainActivity.kt.template", "MainActivity.kt"),
        ("TermuxResultReceiver.kt.template", "TermuxResultReceiver.kt"),
    ):
        template_path = ROOT / "tool" / "android" / template_name
        output_path = activity_path.parent / output_name
        source = template_path.read_text(encoding="utf-8").replace("__PACKAGE_NAME__", package_name)
        output_path.write_text(source, encoding="utf-8")

    manifest = MANIFEST.read_text(encoding="utf-8")
    permission = '    <uses-permission android:name="com.termux.permission.RUN_COMMAND" />'
    if "com.termux.permission.RUN_COMMAND" not in manifest:
        manifest = manifest.replace("<application", permission + "\n\n    <application", 1)

    query = '    <queries>\n        <package android:name="com.termux" />\n    </queries>\n\n'
    if "<queries>" not in manifest:
        manifest = manifest.replace(permission, permission + "\n\n" + query.strip(), 1)

    receiver = '        <receiver android:name=".TermuxResultReceiver" android:exported="false" />'
    if ".TermuxResultReceiver" not in manifest:
        manifest = manifest.replace("</application>", receiver + "\n    </application>", 1)

    MANIFEST.write_text(manifest, encoding="utf-8")
    print("Configured ClawdStudio Termux method-channel adapter.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
