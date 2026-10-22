# Suggested commands
- Install deps: `flutter pub get`.
- Run app: `flutter run -d <device>`.
- Catalog validation: `.venv/bin/python scripts/validate_catalog.py` (venv needs jsonschema + pillow).
- Format check: `dart format --set-exit-if-changed lib test`.
- Analyze: `flutter analyze`.
- Tests: `flutter test`; Eastern package: `flutter test packages/an_nhien_eastern_content/test`.
- Android debug build: `flutter build apk --debug`.
- Device list: `flutter devices` or `adb devices -l`.