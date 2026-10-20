# ClawdStudio agent instructions

## Inspect first
Read this file, README.md, docs/STATUS.md, docs/ARCHITECTURE.md and relevant source/tests before changes. Use current official Flutter, Dart, Android, provider and GitHub documentation. Context7 was unavailable in the initial environment; do not claim it was used. Keep changes small.

## Truthful implementation
Clawd-Code is a Python coding-agent engine, not an AI model. Do not claim capabilities are implemented until code and tests prove them. Prove Android runtime feasibility and one real agent tool call before expanding agent UI. Do not claim physical-phone testing unless it happened. Tie provider capabilities/free-tier labels to dated official sources.

## Safety
Never commit secrets, tokens, signing keys or private workspace content. Use Android secure storage; base64 is not encryption. Any local bridge must bind to loopback by default and require a random pairing token. Scope file tools to the selected workspace. Require approval before destructive commands, broad overwrites, deletion, commit, push or merge. Redact secrets; support cancellation and bounded tool loops. Never silently switch to a paid provider.

## Quality and Git
Run dart format, flutter analyze, flutter test, Android build and git diff --check where tooling is available. Add tests for behavior. Use a feature branch and PR; merge only after required CI checks are green and rules allow it. Keep README and docs/STATUS.md accurate.