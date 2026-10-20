# Android engine runtime spike

**Checked:** 2026-10-20. **Status: research-only decision; no Android device execution verified.**

## Findings

### Option A — embed Python with Chaquopy

Chaquopy is an Android Gradle plugin which embeds Python in an Android app. Current official documentation lists Python 3.10–3.15, Android API 24+, and installation of third-party Python packages through its build integration.

This remains unproven for Clawd-Code. The upstream package imports a terminal-oriented CLI/REPL and has dependencies that must be checked against Chaquopy's Android-compatible wheels. A successful Flutter APK build alone would not prove the agent can initialize, load a provider, execute its tools, or run within mobile memory limits. We should not bundle the full dependency set until a minimal dependency/build spike succeeds.

Official docs: https://chaquo.com/chaquopy/doc/current/android.html and https://chaquo.com/chaquopy/doc/current/versions.html

### Option B — Termux companion runtime

Termux documents a `RUN_COMMAND` intent for third-party Android apps to invoke commands in the Termux environment. The documented setup requires the app to declare and receive `com.termux.permission.RUN_COMMAND`, and Termux's `allow-external-apps` property must be enabled. Returning process output is supported when using the documented Java intent/result path and a sufficiently recent Termux version.

This is the more practical first prototype because Clawd-Code is a Python CLI and Termux provides a conventional Python environment. It is **not yet an integrated or tested solution**: ClawdStudio needs native Android intent/result plumbing, setup diagnostics, an explicit permission explanation, command/result limits, process cancellation, and a noninteractive entry point around the upstream agent loop.

Security and compatibility caveats:
- Treat the Termux permission as powerful: a command invoked by ClawdStudio runs with Termux's privileges. Never pass arbitrary AI-generated shell commands through the bridge.
- Use fixed, app-owned scripts and strict arguments; validate workspace paths and avoid path traversal.
- Do not put API keys in intent extras, logs, command-line arguments, or Git.
- Do not require broad shared-storage access by default; document Android scoped-storage limitations and let the user explicitly select a workspace.
- Handle Termux missing, outdated, denied permission, disabled external commands, background restrictions, timeout, cancellation and process death as explicit states.
- The bridge must not report success merely because an intent was sent; wait for a result and verify the expected output.

Official documentation: https://github.com/termux/termux-app/wiki/RUN_COMMAND-Intent

## Provisional decision

Prototype the **Termux companion path first**, behind an engine adapter, without claiming that the engine is connected. Keep the adapter replaceable so a later embedded Python runtime can be evaluated independently. This is a development choice, not a verified architecture commitment.

## Required next implementation milestone

1. Add a native Android method-channel adapter using Termux's documented intent and result contract.
2. Add a fixed diagnostic command and a fixed headless upstream entry point; do not expose arbitrary shell execution to the model.
3. Pin/record the exact upstream Clawd-Code commit and install only its documented dependencies inside Termux.
4. Add a workspace-scoped safe tool test in a disposable directory (create/read a marker file, then verify its contents).
5. Add unit tests for missing Termux, denied permission, timeout, malformed result and cancellation.
6. Build and install the APK, then verify the complete flow on a physical Android phone with Termux installed.
7. Only after the real test passes, implement provider setup and task UI; do not merge a release claim based only on a CI APK build.

## Verification boundary

This document is based on current official documentation and static inspection of upstream source. No device, emulator, Termux process, provider API, or real Clawd-Code agent run was available in this step. Runtime support remains **not verified**.
