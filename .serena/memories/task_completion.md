# Task completion gates
- Before work: read TRACKER.md, PRINCIPLES.md, relevant LEARNINGS.md, and relevant 01_..05_ spec sections.
- Catalog/assets/scripts changes: run `.venv/bin/python scripts/validate_catalog.py` (jsonschema + pillow required).
- Flutter code changes: `flutter pub get`; `dart format --set-exit-if-changed lib test`; `flutter analyze`; `flutter test`.
- Changed local package assets should also run its package tests and a relevant root targeted test.
- Observe changed behavior on its real surface (emulator/device for Flutter) before DONE; record commands/results and remaining risks in TRACKER.md.
- Important defects follow Detect -> Root Cause -> Fix -> Prevent -> Verify -> Record in LEARNINGS.md; promote general verified rules to PRINCIPLES.md.