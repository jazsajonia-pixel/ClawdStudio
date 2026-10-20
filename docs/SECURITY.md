# Security notes
Preliminary checklist, not a security audit.

- Never embed provider keys, GitHub tokens/client secrets or signing keys in source or APK.
- Use Android secure storage; base64 is not encryption.
- If a local bridge is used, bind to `127.0.0.1`, require a random pairing token, limit requests/timeouts and never log tokens.
- Scope file access to the selected workspace; canonicalize paths to prevent traversal/symlink escape.
- Require explicit approval before destructive commands, deletion, broad overwrite, commit, push or merge.
- Never automatically retry destructive operations. Support cancellation and bounded tool loops.
- Redact secrets from diagnostics, logs and task history.
- Never silently switch providers or trigger charges.
- Explain that provider requests may include relevant source code/context.
- Treat upstream permissions as incomplete until independently tested.

No bridge, credential store, workspace sandbox or approval engine exists in this branch yet.