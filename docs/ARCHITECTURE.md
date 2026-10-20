# Architecture decision record

**Checked:** 2026-10-20. **Upstream:** [GPT-AGI/Clawd-Code](https://github.com/GPT-AGI/Clawd-Code), inspected `main` commit `5a5e4dd8d6c4a1d486f4d4650adbe7ceefd56c9c`. Its LICENSE reports MIT, Copyright 2026 Clawd Codex Team.

## Decision: provisional, not proven
Embedding Python in the APK is unproven. A Termux-managed engine plus loopback bridge is only a candidate; no Termux launch API, companion setup or bridge has been tested on a real device. A remote engine is not selected. Upstream `src/cli.py` starts an interactive REPL; `src/bridge/__init__.py` is a placeholder for an archived subsystem, not a ready-made HTTP bridge.

## Required spike before broader agent UI
1. Select a runtime after checking current official docs.
2. Run this upstream revision on Android.
3. Implement an authenticated bridge bound to `127.0.0.1`, with request limits/timeouts and workspace-scoped operations.
4. Send a prompt through the real agent loop and display the real response.
5. Execute one safe tool against a disposable workspace.
6. Test cancellation, disconnect, process death, reconnection and errors.
7. Record device/runtime, commands, upstream SHA and evidence.

## Planned layers
- Flutter presentation: setup, workspace, providers, task stream, diffs and approvals.
- Engine adapter: isolates upstream launch/protocol details.
- Companion runtime/bridge if selected: loopback only, authentication required.
- Provider adapters: only compatible with the engine's real tool-call format.
- Workspace: selected-project scope, checkpoints and review before consequential Git actions.
- Secrets: Android secure storage, never logs or source control.

Upstream documentation describes a real CLI/tool loop but also reports incomplete context and permissions. ClawdStudio needs independently tested approval boundaries.