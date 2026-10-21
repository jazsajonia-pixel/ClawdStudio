# Security notes
Preliminary checklist, not a security audit.

- Never embed provider keys, GitHub tokens/client secrets or signing keys in source or APK.
- Use Android secure storage; base64 is not encryption.
- Termux RUN_COMMAND can execute with Termux's privileges. Require explicit permission and the user-controlled `allow-external-apps=true` setting.
- Only the fixed, app-owned diagnostic is exposed in this milestone. Never accept arbitrary AI-generated shell commands through the bridge.
- If a local bridge is added later, bind to `127.0.0.1`, require a random pairing token, limit requests/timeouts and never log tokens.
- Scope file access to the selected workspace; canonicalize paths to prevent traversal/symlink escape.
- Require explicit approval before destructive commands, deletion, broad overwrite, commit, push or merge.
- Never automatically retry destructive operations. Support cancellation and bounded tool loops.
- Redact secrets from diagnostics, logs and task history.
- Never silently switch providers or trigger charges.
- Explain that provider requests may include relevant source code/context.
- Treat upstream permissions as incomplete until independently tested.

The native Termux transport diagnostic is implemented in this branch, but not yet verified on a physical device. No agent bridge, credential store, workspace sandbox or approval engine exists yet.
