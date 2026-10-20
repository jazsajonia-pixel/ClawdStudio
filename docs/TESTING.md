# Testing

## Automated checks
Run with a current stable Flutter SDK:
```sh
flutter pub get
dart format --set-exit-if-changed .
flutter analyze
flutter test
flutter build apk --debug
git diff --check
```
GitHub Actions runs format, analyze, widget tests and a debug APK build. Inspect the actual workflow run before claiming success.

## Engine smoke test (not implemented yet)
1. Create a disposable workspace with a known text file.
2. Start engine and verify authenticated loopback health.
3. Send a prompt asking it to read the file and display the actual response.
4. Request a small edit; inspect the real diff.
5. Approve a safe tool action and verify file output.
6. Cancel a long task and confirm execution stops.
7. Revoke bridge token and confirm requests are rejected.
8. Attempt a path outside the workspace and confirm denial.
9. Test missing/invalid/rate-limited/valid provider credentials.
Do not use real project files or secrets. Record physical-phone testing separately from CI/emulator checks.