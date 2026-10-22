import 'package:flutter/painting.dart';

/// Layer 1 — raw values. Only semantic tokens may reference these; widgets never do.
abstract final class PrimitiveColors {
  static const teal900 = Color(0xFF073F3B);
  static const teal800 = Color(0xFF0A5249);
  static const teal700 = Color(0xFF0E685E);
  static const ink900 = Color(0xFF173B34);
  static const sage700 = Color(0xFF4E655D);
  static const sage200 = Color(0xFFE3E7DF);
  static const cream50 = Color(0xFFFAF9F3);
  static const white = Color(0xFFFFFFFF);
  static const terracotta700 = Color(0xFFA0412A);
  static const amber800 = Color(0xFF8A5A00);
  static const green700 = Color(0xFF2E6B3A);

  // Night palette: soft cream on deep teal, no pure white/black (evening glare).
  static const night950 = Color(0xFF04201E);
  static const night900 = Color(0xFF0A2F2B);
  static const night600 = Color(0xFF3F6A62);
  static const nightText = Color(0xFFF2EFE6);
  static const nightTextMuted = Color(0xFFB7C9C3);
  static const mint300 = Color(0xFF7FD1BC);
  static const mint200 = Color(0xFF9BE0CE);
  static const coral300 = Color(0xFFFF9C85);
  static const gold300 = Color(0xFFF2C14E);
  static const leaf300 = Color(0xFF8FD19E);
}

/// 4/8pt scale.
abstract final class PrimitiveSpacing {
  static const s4 = 4.0;
  static const s8 = 8.0;
  static const s12 = 12.0;
  static const s16 = 16.0;
  static const s20 = 20.0;
  static const s24 = 24.0;
  static const s32 = 32.0;
}

abstract final class PrimitiveRadius {
  static const r12 = 12.0;
  static const r16 = 16.0;
  static const r24 = 24.0;
}

/// Font sizes in logical pixels (scaled by the OS text scaler at render time).
abstract final class PrimitiveFontSizes {
  static const f14 = 14.0;
  static const f16 = 16.0;
  static const f18 = 18.0;
  static const f20 = 20.0;
  static const f26 = 26.0;
  static const f28 = 28.0;
  static const f34 = 34.0;
  static const f112 = 112.0;
}

abstract final class PrimitiveFontWeights {
  static const regular = FontWeight.w400;
  static const medium = FontWeight.w500;
  static const semibold = FontWeight.w600;
}

abstract final class PrimitiveSizes {
  static const s1 = 1.0;
  static const s3 = 3.0;
  static const s5 = 5.0;
  static const s12 = 12.0;
  static const s32 = 32.0;
  static const s48 = 48.0;
  static const s52 = 52.0;
  static const s56 = 56.0;
  static const s72 = 72.0;
  static const s96 = 96.0;
  static const s180 = 180.0;
  static const s220 = 220.0;
}
