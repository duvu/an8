import 'package:flutter/material.dart';

import 'component_tokens.dart';
import 'semantic_tokens.dart';

/// Maps design tokens onto Material [ThemeData]; the only place tokens meet Material.
abstract final class AppTheme {
  static ThemeData get light => _build(AppColors.light, Brightness.light);
  static ThemeData get night => _build(AppColors.night, Brightness.dark);

  static ThemeData _build(AppColors colors, Brightness brightness) {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: colors.accent,
          brightness: brightness,
        ).copyWith(
          primary: colors.accent,
          onPrimary: colors.onAccent,
          error: colors.danger,
          onError: colors.onAccent,
          surface: colors.surface,
          onSurface: colors.textPrimary,
          onSurfaceVariant: colors.textSecondary,
          surfaceContainerLowest: colors.surfaceElevated,
          outline: colors.border,
          outlineVariant: colors.border,
        );

    final textTheme = const TextTheme(
      headlineSmall: AppTypography.headline,
      titleLarge: AppTypography.title,
      titleMedium: AppTypography.label,
      titleSmall: AppTypography.label,
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.body,
      bodySmall: AppTypography.auxiliary,
      labelLarge: AppTypography.label,
      labelMedium: AppTypography.auxiliary,
      labelSmall: AppTypography.auxiliary,
    ).apply(bodyColor: colors.textPrimary, displayColor: colors.textPrimary);

    const buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(ButtonTokens.radius)),
    );
    const buttonMinimumSize = Size(
      ButtonTokens.minHeight,
      ButtonTokens.minHeight,
    );
    const buttonPadding = EdgeInsets.symmetric(
      horizontal: ButtonTokens.horizontalPadding,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colors.surface,
      focusColor: colors.focusRing.withValues(alpha: 0.24),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      extensions: [colors],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        titleTextStyle: textTheme.titleLarge,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        barrierColor: colors.surface.withValues(
          alpha: DialogTokens.scrimOpacity,
        ),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyLarge,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(DialogTokens.radius),
          ),
          side: BorderSide(
            color: colors.border,
            width: DialogTokens.borderWidth,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(CardTokens.radius),
          ),
          side: BorderSide(color: colors.border, width: CardTokens.borderWidth),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonMinimumSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonMinimumSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: textTheme.labelLarge,
          // Accent outline: the decorative border token is too faint for a control.
          side: BorderSide(
            color: colors.accent,
            width: ButtonTokens.outlineWidth,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: buttonMinimumSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size.square(IconButtonTokens.minTapTarget),
        ),
      ),
      dividerTheme: DividerThemeData(color: colors.border),
    );
  }
}
