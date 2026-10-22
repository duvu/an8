import 'semantic_tokens.dart';
import 'primitive_tokens.dart';

/// Layer 3 — per-component decisions built from semantic tokens.
abstract final class ButtonTokens {
  static const minHeight = PrimitiveSizes.s52;
  static const radius = AppRadius.sm;
  static const horizontalPadding = AppSpacing.xl;
  static const outlineWidth = PrimitiveSizes.s1;
}

abstract final class IconButtonTokens {
  static const minTapTarget = PrimitiveSizes.s48;
}

abstract final class CardTokens {
  static const radius = AppRadius.md;
  static const borderWidth = PrimitiveSizes.s1;
}

/// Dialogs share the card language: elevated surface, hairline border.
abstract final class DialogTokens {
  static const radius = AppRadius.lg;
  static const borderWidth = PrimitiveSizes.s1;

  /// Scrim tinted with the surface colour instead of Material's grey.
  static const scrimOpacity = 0.8;
  static const brandMarkSize = PrimitiveSizes.s32;
}

abstract final class IconSizes {
  static const listThumbnail = PrimitiveSizes.s56;
}

abstract final class MotionTokens {
  static const frameCrossfade = Duration(milliseconds: 300);
}

abstract final class DistanceViewTokens {
  /// Progress frame drawn around the exercise image.
  static const frameStrokeWidth = PrimitiveSizes.s12;
  static const frameGap = PrimitiveSpacing.s4;
  static const frameRadius = PrimitiveRadius.r24;

  /// Share of the available height the framed image may take.
  static const mediaHeightFraction = 0.4;
  static const mediaLandscapeHeightFraction = 0.75;

  /// Portrait height kept for header, digits, status line and pinned controls
  /// (at text scale 1.0); the image shrinks on short screens instead.
  static const portraitReservedHeight = 430.0;
  static const mediaMinSide = 120.0;
  static const controlHeight = PrimitiveSizes.s72;

  static const pulsePeriod = Duration(seconds: 6);
  static const announce = Duration(milliseconds: 400);
}

abstract final class EasternTokens {
  static const listCoverWidth = PrimitiveSizes.s72;
  static const detailCoverWidth = PrimitiveSizes.s220;
  static const formThumbnailWidth = PrimitiveSizes.s48;

  /// Overview boards are dense (8 forms per page): allow close zoom.
  static const overviewMaxZoom = 4.0;
}

/// The canonical An lockup (lotus + wordmark) from `package:an_brand`.
abstract final class BrandTokens {
  static const double appBarLockupHeight = 32;
  static const double onboardingLockupHeight = 72;
}

abstract final class SplashTokens {
  /// Native launch images are drawn from these numbers
  /// (`scripts/build_launch_screen.py`); change both together.
  static const double lockupHeight = 96;

  /// The lockup image has empty space on its right; this share of its width
  /// holds the artwork, so the visible logo sits in the middle of the screen.
  static const double lockupContentWidthFactor = 0.55;
  static const hold = Duration(milliseconds: 1800);
}

abstract final class CalendarTokens {
  static const cellMargin = PrimitiveSpacing.s4;
  static const todayBorderWidth = PrimitiveSizes.s1;
  static const markerSize = PrimitiveSpacing.s8;
}

abstract final class HealthTokens {
  static const chartHeight = PrimitiveSizes.s180;
  static const chartStrokeWidth = PrimitiveSizes.s3;
  static const chartPointRadius = PrimitiveSizes.s5;

  /// Narrowest blood-pressure box (at text scale 1) that still sits three in
  /// a row; narrower screens or larger text stack the boxes.
  static const pressureBoxMinWidth = PrimitiveSizes.s96;

  /// Readings drawn in the chart (newest ones).
  static const chartMaxPoints = 30;
}
