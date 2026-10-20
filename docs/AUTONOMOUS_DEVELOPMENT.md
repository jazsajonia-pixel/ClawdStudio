# Autonomous development loop

## One-time setup

1. Open **Settings → Secrets and variables → Actions → New repository secret**.
2. Add `GEMINI_API_KEY` using an API key from Google AI Studio. The Gemini API free tier is quota-limited; verify current limits and monitor usage.
3. Merge the setup PR into `main`; scheduled workflows only run from the default branch.
4. Use **Actions → ClawdStudio Autonomous Development → Run workflow** for the first test.

## Behavior

- Runs every 30 minutes and supports manual dispatch.
- Uses a concurrency group with `cancel-in-progress: false`; a new timer tick will not cancel the active run.
- Works on the existing Termux diagnostic PR branch while it exists; otherwise creates a persistent automation branch.
- Runs the official Google Gemini CLI GitHub Action (`google-github-actions/run-gemini-cli`) with Gemini API authentication, then runs Dart formatting, analysis, Flutter tests, and a debug APK build.
- Commits incremental work and creates or updates a PR. If there are changes and work remains, it queues up to three immediate follow-up passes; the scheduled timer resumes later.
- If Gemini explicitly reports production-candidate completion or a human-only blocker, the workflow writes `.github/AUTONOMOUS_DEV_PAUSED` and stops future passes until that marker is removed.
- If checks fail, changes are preserved for a later repair pass. A failed check is never treated as production-ready.

## Boundaries and costs

The workflow does **not** auto-merge, sign, or publish releases. The app still needs verified real Termux/agent execution, physical-device acceptance, and release signing before a production APK can be claimed. GitHub cron is best-effort, not an exact timer. Immediate continuation is capped at three chained runs to prevent runaway API spending. Gemini API usage is subject to the selected model's current quota and billing terms. A free-tier quota is not guaranteed to support every 30-minute run.
