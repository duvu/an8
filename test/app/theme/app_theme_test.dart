import 'package:an_nhien/app/theme/app_theme.dart';
import 'package:an_nhien/app/theme/component_tokens.dart';
import 'package:an_nhien/app/theme/semantic_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// WCAG 2.x contrast ratio.
double contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final lighter = la > lb ? la : lb;
  final darker = la > lb ? lb : la;
  return (lighter + 0.05) / (darker + 0.05);
}

void _contrastTests(AppColors colors) {
  const textMin = 4.5;
  const nonTextMin = 3.0;
  final backgrounds = {
    'surface': colors.surface,
    'surfaceElevated': colors.surfaceElevated,
  };
  final textColors = {
    'textPrimary': colors.textPrimary,
    'textSecondary': colors.textSecondary,
    'accent': colors.accent,
    'danger': colors.danger,
    'warning': colors.warning,
    'success': colors.success,
  };

  for (final bg in backgrounds.entries) {
    for (final fg in textColors.entries) {
      test('${fg.key} on ${bg.key} >= $textMin', () {
        expect(
          contrastRatio(fg.value, bg.value),
          greaterThanOrEqualTo(textMin),
        );
      });
    }
    test('focusRing on ${bg.key} >= $nonTextMin', () {
      expect(
        contrastRatio(colors.focusRing, bg.value),
        greaterThanOrEqualTo(nonTextMin),
      );
    });
  }

  for (final (name, background) in [
    ('accent', colors.accent),
    ('warning', colors.warning),
    ('danger', colors.danger),
  ]) {
    test('onAccent on $name >= $textMin (filled controls, badges)', () {
      expect(
        contrastRatio(colors.onAccent, background),
        greaterThanOrEqualTo(textMin),
      );
    });
  }
}

void main() {
  const colors = AppColors.light;
  final theme = AppTheme.light;

  group('AppColors.light contrast (WCAG AA)', () => _contrastTests(colors));
  group('AppColors.night contrast (WCAG AA)', () {
    _contrastTests(AppColors.night);
  });

  test('night theme maps tokens and is dark', () {
    final night = AppTheme.night;
    expect(night.brightness, Brightness.dark);
    expect(night.appColors, same(AppColors.night));
    expect(night.colorScheme.surface, AppColors.night.surface);
    expect(night.scaffoldBackgroundColor, AppColors.night.surface);
  });

  group('AppTheme.light maps tokens', () {
    test('exposes semantic colors as a theme extension', () {
      expect(theme.appColors, same(colors));
    });

    test('color scheme uses semantic tokens', () {
      final scheme = theme.colorScheme;
      expect(scheme.primary, colors.accent);
      expect(scheme.onPrimary, colors.onAccent);
      expect(scheme.error, colors.danger);
      expect(scheme.surface, colors.surface);
      expect(scheme.onSurface, colors.textPrimary);
      expect(theme.scaffoldBackgroundColor, colors.surface);
    });

    test('no text style is smaller than 14sp', () {
      final styles = [
        theme.textTheme.headlineSmall,
        theme.textTheme.titleLarge,
        theme.textTheme.titleMedium,
        theme.textTheme.titleSmall,
        theme.textTheme.bodyLarge,
        theme.textTheme.bodyMedium,
        theme.textTheme.bodySmall,
        theme.textTheme.labelLarge,
        theme.textTheme.labelMedium,
        theme.textTheme.labelSmall,
      ];
      for (final style in styles) {
        expect(style?.fontSize, greaterThanOrEqualTo(14));
      }
    });

    testWidgets('buttons are at least 52dp tall and icon buttons 48dp', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: Column(
              children: [
                FilledButton(onPressed: () {}, child: const Text('A')),
                OutlinedButton(onPressed: () {}, child: const Text('B')),
                TextButton(onPressed: () {}, child: const Text('C')),
                IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
              ],
            ),
          ),
        ),
      );

      for (final type in [FilledButton, OutlinedButton, TextButton]) {
        expect(
          tester.getSize(find.byType(type)).height,
          greaterThanOrEqualTo(ButtonTokens.minHeight),
        );
      }
      final iconSize = tester.getSize(find.byType(IconButton));
      expect(
        iconSize.width,
        greaterThanOrEqualTo(IconButtonTokens.minTapTarget),
      );
      expect(
        iconSize.height,
        greaterThanOrEqualTo(IconButtonTokens.minTapTarget),
      );
    });
  });
}
