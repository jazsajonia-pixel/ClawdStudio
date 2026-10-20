# Status
**Last checked:** 2026-10-20

## Implemented
- Flutter/Dart app shell with Home, Engine and Settings navigation.
- Material dark/light themes following the system.
- Honest disconnected/unconfigured/unselected states.
- Upstream revision/license inspection, initial widget tests and GitHub Actions workflow.
- Runtime options researched; Termux `RUN_COMMAND` is the provisional prototype path, documented in `docs/ENGINE_SPIKE.md`.

## Not implemented
- Native Termux intent/result adapter, setup diagnostics, or fixed headless engine entry point.
- Python/Termux runtime integration; real agent prompt/tool execution.
- Provider adapters, model catalog, secure API-key storage or connection tests.
- GitHub OAuth, repository workspace, Git operations, diffs or approvals.
- Task cancellation/history/recovery; app-specific LICENSE selection; APK prerelease.

## Verification
- Previous foundation CI run #39425224277 passed formatting, analyzer, widget tests, and Android debug APK build at `59c65c2932b8db5fad7ac293d6d1faca762d994a`.
- Static runtime research completed against current official Chaquopy and Termux documentation.
- This step did not run local Flutter commands, install the app, invoke Termux, call a provider API, or run Clawd-Code on an emulator/physical device. The runtime path is **not verified**.
