# Autonomous development loop

## Status: paused by owner (2026-10-20)

The owner cancelled the scheduled Gemini development loop after repeated failures. The workflow no longer has a 30-minute cron trigger, and `.github/AUTONOMOUS_DEV_PAUSED` prevents a manual dispatch from running Gemini or making changes. The immediate continuation chain was removed. Do not resume unless the owner explicitly asks.

## Previous behavior (for reference)

The former workflow used Gemini CLI with a serialized GitHub Actions job, Flutter formatting/analysis/tests/debug APK build, incremental commits and PR creation. It did not auto-merge or publish releases. The first manual Gemini run failed because the CLI did not trust the workspace; a subsequent run also failed. ChatGPT daily sessions are the preferred development workflow now.
