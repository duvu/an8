# Tech stack
- Flutter 3.47.5 stable; Dart 3.13.4; Android + iOS project at repo root.
- State/DI: flutter_riverpod. Navigation: go_router. Localization: Flutter gen-l10n/intl, vi-VN.
- Persistence: sqflite/path; tests use sqflite_common_ffi.
- Audio: just_audio + audio_session. Notifications: flutter_local_notifications/timezone/flutter_timezone.
- Local packages include packages/an_nhien_eastern_content and packages/an_nhien_cultural_content.
- Catalog/tooling scripts are Python; validator requires jsonschema + Pillow.