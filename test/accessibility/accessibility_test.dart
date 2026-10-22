import 'package:an_nhien/app/app.dart';
import 'package:an_nhien/app/router/app_router.dart';
import 'package:an_nhien/app/router/app_routes.dart';
import 'package:an_nhien/features/settings/domain/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_app.dart';

/// PRD F06: every core screen at text scale 1.0 / 1.5 / 2.0 on a normal and a
/// small phone renders without overflow and meets tap-target/label guidelines.
void main() {
  final screens = <String, String>{
    'Splash': AppRoutes.splash,
    'Home': AppRoutes.home,
    'Calendar': AppRoutes.calendar,
    'Library': AppRoutes.library,
    'Progress': AppRoutes.progress,
    'Settings': AppRoutes.settings,
    'Detail': AppRoutes.routine('R02'),
    'Preflight': AppRoutes.preflight('R02'),
    'Player': AppRoutes.session('R02'),
    'Safety': AppRoutes.safety,
    'Downloads': AppRoutes.downloads,
    'Eastern': AppRoutes.eastern,
    'EasternDetail': AppRoutes.easternSystem('taichi24'),
    'EasternResearch': AppRoutes.easternSystem('xisuijing'),
    'EasternForm': AppRoutes.easternForm('baduanjin', 'E101'),
    'EasternTaichi': AppRoutes.easternSystem('taichi24'),
    'EasternOverview': AppRoutes.easternOverview('taichi24', 'tc24-01-08'),
    'ExerciseLearn': AppRoutes.exerciseLearn('E101'),
    'Story': AppRoutes.storyEpisode('EP05'),
    'HealthConsent': AppRoutes.health,
    'HealthMetric': AppRoutes.healthMetric('bloodPressure'),
    'HealthAdd': AppRoutes.healthAdd(),
    'HealthAddGlucose': AppRoutes.healthAdd('bloodGlucose'),
    'HealthExport': AppRoutes.healthExport,
  };
  const scales = [1.0, 1.5, 2.0];
  const phones = {
    '360x780': Size(1080, 2340),
    '320x568 (small)': Size(960, 1704),
  };

  Future<TestApp> go(
    WidgetTester tester,
    String location,
    double scale,
    Size phone, {
    Preferences preferences = const Preferences(onboardingCompleted: true),
  }) async {
    final app = await pumpTestApp(tester, preferences: preferences);
    tester.view.physicalSize = phone;
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final context = tester.element(find.byType(AnNhienApp));
    ProviderScope.containerOf(context).read(appRouterProvider).go(location);
    // Bounded pumps: the distance view's looping glow never "settles".
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await settleIo(tester);
    if (location.startsWith('/session/')) {
      await app.elapse(const Duration(seconds: 4)); // past countdown, playing
    }
    return app;
  }

  for (final MapEntry(key: phoneName, value: phone) in phones.entries) {
    for (final scale in scales) {
      for (final MapEntry(key: name, value: location) in screens.entries) {
        testWidgets('$name renders at text scale $scale on $phoneName', (
          tester,
        ) async {
          final app = await go(tester, location, scale, phone);
          // Layout overflow is reported by the framework and fails the test.
          await app.dispose();
        });
      }
    }
  }

  for (final MapEntry(key: name, value: location) in screens.entries) {
    testWidgets('$name meets tap-target, label and contrast guidelines', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final app = await go(tester, location, 1.0, phones.values.first);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await app.dispose();
      handle.dispose();
    });
  }

  testWidgets('Onboarding renders at text scale 2.0 on a small phone', (
    tester,
  ) async {
    final app = await pumpTestApp(tester, preferences: const Preferences());
    tester.view.physicalSize = phones.values.last;
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpAndSettle();
    await app.dispose();
  });

  testWidgets('player exposes state to screen readers', (tester) async {
    final handle = tester.ensureSemantics();
    final app = await go(
      tester,
      AppRoutes.session('R01'),
      1.0,
      phones.values.first,
    );

    // Always visible without scrolling: the step timer (name + time left).
    expect(
      find.bySemanticsLabel(RegExp(r'^Thở tự nhiên, còn lại \d\d:\d\d$')),
      findsOneWidget,
    );
    expect(find.byTooltip('Bước trước'), findsOneWidget);
    expect(find.byTooltip('Bước tiếp'), findsOneWidget);
    expect(
      find.bySemanticsLabel('Ngồi vững, vai và hàm thả lỏng.'),
      findsWidgets,
    );
    await app.dispose();
    handle.dispose();
  });

  testWidgets('summary renders at text scale 2.0', (tester) async {
    final app = await go(
      tester,
      AppRoutes.session('R01'),
      2.0,
      phones.values.last,
    );
    await app.elapse(const Duration(minutes: 7));
    await tester.pumpAndSettle();
    await settleIo(tester);
    expect(find.text('Hoàn thành bài tập'), findsOneWidget);
    await app.dispose();
  });

  group('distance view (phone 1–2 m away)', () {
    const distance = Preferences(onboardingCompleted: true);
    const landscape = Size(2400, 1080); // 800 x 360 dp
    final devices = {...phones, '800x360 (landscape)': landscape};

    for (final MapEntry(key: deviceName, value: device) in devices.entries) {
      for (final scale in scales) {
        testWidgets('renders at text scale $scale on $deviceName', (
          tester,
        ) async {
          final app = await go(
            tester,
            AppRoutes.session('R02'),
            scale,
            device,
            preferences: distance,
          );
          // Overflow is reported by the framework and fails the test.
          await app.dispose();
        });
      }

      testWidgets('keeps the image and Pause on screen at $deviceName', (
        tester,
      ) async {
        final app = await go(
          tester,
          AppRoutes.session('R02'),
          1.0,
          device,
          preferences: distance,
        );
        final screen = Offset.zero & tester.view.physicalSize / 3;
        for (final label in ['Tạm dừng']) {
          final rect = tester.getRect(
            find
                .ancestor(
                  of: find.text(label),
                  matching: find.bySubtype<ButtonStyleButton>(),
                )
                .first,
          );
          expect(screen.contains(rect.topLeft), isTrue, reason: '$label top');
          expect(screen.contains(rect.bottomRight), isTrue, reason: label);
        }
        // The pause panel (Tiếp tục / Dừng hẳn) fits on screen too.
        await tester.tap(find.widgetWithText(FilledButton, 'Tạm dừng'));
        for (var i = 0; i < 6; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        for (final label in ['Tiếp tục', 'Dừng hẳn']) {
          final rect = tester.getRect(
            find.descendant(
              of: find.byType(Dialog),
              matching: find.text(label),
            ),
          );
          expect(screen.contains(rect.topLeft), isTrue, reason: label);
          expect(screen.contains(rect.bottomRight), isTrue, reason: label);
        }
        Navigator.of(tester.element(find.byType(Dialog))).pop();
        for (var i = 0; i < 4; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        // P15: the exercise image is shown in every layout.
        expect(
          find.byWidgetPredicate(
            (w) =>
                w is Image &&
                w.semanticLabel == 'Ngồi vững, vai và hàm thả lỏng.',
          ),
          findsOneWidget,
        );
        await app.dispose();
      });
    }

    testWidgets('meets tap-target, label and contrast guidelines', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final app = await go(
        tester,
        AppRoutes.session('R01'),
        1.0,
        phones.values.first,
        preferences: distance,
      );
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await app.dispose();
      handle.dispose();
    });

    testWidgets('timer is announced with step name and time', (tester) async {
      final handle = tester.ensureSemantics();
      final app = await go(
        tester,
        AppRoutes.session('R01'),
        1.0,
        phones.values.first,
        preferences: distance,
      );
      expect(
        find.bySemanticsLabel(RegExp(r'^Thở tự nhiên, còn lại \d\d:\d\d$')),
        findsOneWidget,
      );
      await app.dispose();
      handle.dispose();
    });
  });

  testWidgets('pause panel renders at text scale 2.0 on a small phone', (
    tester,
  ) async {
    final app = await go(
      tester,
      AppRoutes.session('R01'),
      2.0,
      phones.values.last,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Tạm dừng'));
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.byType(Dialog), findsOneWidget);
    // Overflow is reported by the framework and fails the test.
    await app.dispose();
  });

  group('health overview (after consent)', () {
    const consented = Preferences(
      onboardingCompleted: true,
      healthConsent: true,
    );
    for (final MapEntry(key: phoneName, value: phone) in phones.entries) {
      for (final scale in scales) {
        testWidgets('renders at text scale $scale on $phoneName', (
          tester,
        ) async {
          final app = await go(
            tester,
            AppRoutes.health,
            scale,
            phone,
            preferences: consented,
          );
          expect(find.text('Ghi chỉ số'), findsOneWidget);
          await app.dispose();
        });
      }
    }

    testWidgets('meets tap-target, label and contrast guidelines', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final app = await go(
        tester,
        AppRoutes.health,
        1.0,
        phones.values.first,
        preferences: consented,
      );
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await app.dispose();
      handle.dispose();
    });
  });
}
