import 'package:flutter/material.dart';

import 'primitive_tokens.dart';

/// Layer 2 — meaning-based colors, exposed to widgets via
/// `Theme.of(context).extension<AppColors>()!` or [AppColorsX.appColors].
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.surface,
    required this.surfaceElevated,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.accent,
    required this.onAccent,
    required this.danger,
    required this.warning,
    required this.success,
    required this.focusRing,
  });

  /// Text/status colors meet WCAG AA (>= 4.5:1) on [surface] and
  /// [surfaceElevated]; [border] is decorative only (see test/app/theme).
  static const light = AppColors(
    surface: PrimitiveColors.cream50,
    surfaceElevated: PrimitiveColors.white,
    textPrimary: PrimitiveColors.ink900,
    textSecondary: PrimitiveColors.sage700,
    border: PrimitiveColors.sage200,
    accent: PrimitiveColors.teal800,
    onAccent: PrimitiveColors.cream50,
    danger: PrimitiveColors.terracotta700,
    warning: PrimitiveColors.amber800,
    success: PrimitiveColors.green700,
    focusRing: PrimitiveColors.teal700,
  );

  /// Evening / distance-view palette. Same contrast rules as [light]
  /// (test/app/theme): text and status colors >= 4.5:1 on both surfaces.
  static const night = AppColors(
    surface: PrimitiveColors.night950,
    surfaceElevated: PrimitiveColors.night900,
    textPrimary: PrimitiveColors.nightText,
    textSecondary: PrimitiveColors.nightTextMuted,
    border: PrimitiveColors.night600,
    accent: PrimitiveColors.mint300,
    onAccent: PrimitiveColors.night950,
    danger: PrimitiveColors.coral300,
    warning: PrimitiveColors.gold300,
    success: PrimitiveColors.leaf300,
    focusRing: PrimitiveColors.mint200,
  );

  final Color surface;
  final Color surfaceElevated;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color accent;
  final Color onAccent;
  final Color danger;
  final Color warning;
  final Color success;
  final Color focusRing;

  @override
  AppColors copyWith({
    Color? surface,
    Color? surfaceElevated,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? accent,
    Color? onAccent,
    Color? danger,
    Color? warning,
    Color? success,
    Color? focusRing,
  }) {
    return AppColors(
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      danger: danger ?? this.danger,
      warning: warning ?? this.warning,
      success: success ?? this.success,
      focusRing: focusRing ?? this.focusRing,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      success: Color.lerp(success, other.success, t)!,
      focusRing: Color.lerp(focusRing, other.focusRing, t)!,
    );
  }
}

extension AppColorsX on ThemeData {
  AppColors get appColors => extension<AppColors>()!;
}

abstract final class AppSpacing {
  static const xs = PrimitiveSpacing.s4;
  static const sm = PrimitiveSpacing.s8;
  static const md = PrimitiveSpacing.s12;
  static const lg = PrimitiveSpacing.s16;
  static const xl = PrimitiveSpacing.s24;
  static const xxl = PrimitiveSpacing.s32;
  static const pageHorizontal = PrimitiveSpacing.s20;
}

abstract final class AppRadius {
  static const sm = PrimitiveRadius.r12;
  static const md = PrimitiveRadius.r16;
  static const lg = PrimitiveRadius.r24;
}

/// Semantic type scale (wireframe spec §8). Nothing below 14sp.
abstract final class AppTypography {
  static const headline = TextStyle(
    fontSize: PrimitiveFontSizes.f26,
    fontWeight: PrimitiveFontWeights.semibold,
    height: 1.3,
  );
  static const title = TextStyle(
    fontSize: PrimitiveFontSizes.f20,
    fontWeight: PrimitiveFontWeights.semibold,
    height: 1.35,
  );
  static const bodyLarge = TextStyle(
    fontSize: PrimitiveFontSizes.f18,
    fontWeight: PrimitiveFontWeights.regular,
    height: 1.5,
  );
  static const body = TextStyle(
    fontSize: PrimitiveFontSizes.f16,
    fontWeight: PrimitiveFontWeights.regular,
    height: 1.5,
  );
  static const label = TextStyle(
    fontSize: PrimitiveFontSizes.f16,
    fontWeight: PrimitiveFontWeights.medium,
    height: 1.4,
  );
  static const auxiliary = TextStyle(
    fontSize: PrimitiveFontSizes.f14,
    fontWeight: PrimitiveFontWeights.regular,
    height: 1.4,
  );
}

/// Type for reading from 1–2 m away (distance view). Nothing here scales below
/// the normal scale; very large values rely on FittedBox at the call site.
abstract final class DistanceTypography {
  static const time = TextStyle(
    fontSize: PrimitiveFontSizes.f112,
    fontWeight: PrimitiveFontWeights.semibold,
    height: 1.0,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const title = TextStyle(
    fontSize: PrimitiveFontSizes.f34,
    fontWeight: PrimitiveFontWeights.semibold,
    height: 1.25,
  );
  static const body = TextStyle(
    fontSize: PrimitiveFontSizes.f28,
    fontWeight: PrimitiveFontWeights.regular,
    height: 1.4,
  );
}
