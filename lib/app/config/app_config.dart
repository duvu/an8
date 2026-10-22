import 'package:flutter/foundation.dart';

abstract final class AppConfig {
  /// Developer preview of draft/demo content (P03). On in debug/profile;
  /// release builds need `--dart-define=AN_NHIEN_PREVIEW_CONTENT=true`.
  static const allowPreviewContent = bool.fromEnvironment(
    'AN_NHIEN_PREVIEW_CONTENT',
    defaultValue: !kReleaseMode,
  );
}
