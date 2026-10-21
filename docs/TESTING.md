# Testing

## Automated checks
Run with a current stable Flutter SDK:
```sh
flutter pub get
python3 tool/configure_android.py
dart format --set-exit-if-changed .
flutter analyze
flutter test
flutter build apk --debug
git diff --check
``
GitHub Actions runs formatting, analyzer, Flutter tests, and an Android debug APK build. It also applies the native bridge template to the generated Android scaffold. Inspect the actual workflow run before claiming success.

## Termux transport diagnostic
1. Install Termux from an official source and open it once.
2. In Termux, set `allow-external-apps=true` in `~/.termux/termux.properties`, then restart Termux.
3. Grant ClawdStudio the `com.termux.permission.RUN_COMMAND` permission through Android app settings.
4. Open Engine in ClawdStudio, tap **Check Termux setup**, then **Run safe diagnostic**.
5. Confirm the app receives `CLAWDSTUDIO_TERMUX_OK` and a successful exit code.

The diagnostic runs a fixed `printf` command and does not accept arbitrary commands. Test missing Termux, missing permission, disabled external-app setting, timeout and process death separately. CI compilation does not prove the intent succeeds on a device.

## Full engine smoke test (not implemented)
1. Create a disposable workspace with a known text file.
2. Start the pinned upstream Clawd-Code agent through a fixed noninteractive entry point.
3. Send a prompt asking it to read the file and display the actual response.
4. Request a small edit; inspect the real diff.
5. Approve a safe tool action and verify file output.
6. Cancel a long task and confirm execution stops.
7. Attempt a path outside the workspace and confirm denial.
8. Test invalid/valid provider credentials without committing secrets.

Do not use real project files or secrets. Record physical-phone testing separately from CI/emulator checks.
