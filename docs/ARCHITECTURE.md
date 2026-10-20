# Architecture decision record

**Checked:** 2026-10-20. **Upstream:** [GPT-AGI/Clawd-Code](https://github.com/GPT-AGI/Clawd-Code), inspected `main` commit `5a5e4dd8d6c4a1d486f4d4650adbe7ceefd56c9c`. Its LICENSE reports MIT, Copyright 2026 Clawd Codex Team.

## Decision: Termux companion path for first prototype (unverified)

Chaquopy can embed Python in Android, but dependency compatibility and noninteractive agent initialization have not been proven for this upstream project. The provisional first path is a Termux companion runtime using the documented `RUN_COMMAND` intent/result contract. Termux must be installed separately, and ClawdStudio must request permission and explain the security implications. This is a prototype choice, not a claim that integration works.

Official feasibility notes and limitations: [Engine runtime spike](ENGINE_SPIKE.md).

Upstream `src/cli.py` starts an interactive REPL; `src/bridge/__init__.py` is a placeholder for an archived subsystem, not a ready-made HTTP bridge. A fixed headless entry point must be implemented around the real agent loop rather than pretending the CLI itself is an app API.

## Required spike before broader agent UI
1. Add a native Android adapter for Termux command invocation and result delivery.
2. Run the pinned upstream revision in Termux with supported dependencies.
3. Add a fixed, noninteractive entry point with workspace-scoped operations; do not pass arbitrary AI-generated shell commands.
4. Send a prompt through the real agent loop and display the real response.
5. Execute one safe tool against a disposable workspace.
6. Test permission denial, cancellation, timeout, process death and reconnection.
7. Record device/runtime, commands, upstream SHA and evidence.

## Planned layers
- Flutter presentation: setup, workspace, providers, task stream, diffs and approvals.
- Engine adapter: isolates Termux launch/result details and remains replaceable.
- Termux companion: pinned upstream checkout, provider config and fixed headless runner.
- Provider adapters: only compatible with the engine's real tool-call format.
- Workspace: selected-project scope, checkpoints and review before consequential Git actions.
- Secrets: Android secure storage where feasible; never logs or source control.

Upstream documentation describes a real CLI/tool loop but also reports incomplete context and permissions. ClawdStudio needs independently tested approval boundaries.
