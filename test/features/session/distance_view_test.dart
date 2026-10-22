import 'package:an_nhien/app/app.dart';
import 'package:an_nhien/app/router/app_router.dart';
import 'package:an_nhien/app/router/app_routes.dart';
import 'package:an_nhien/app/theme/semantic_tokens.dart';
import 'package:an_nhien/features/session/presentation/distance_timer_view.dart';
import 'package:an_nhien/features/settings/domain/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_app.dart';
import '../catalog/catalog_test_data.dart';

const _distance = Preferences(onboardingCompleted: true);

Future<TestApp> _startInDistanceView(
  WidgetTester tester, {
  Preferences preferences = _distance,
}) async {
  final app = await pumpTestApp(tester, preferences: preferences);
  await openPlayerFromHome(tester);
  return app;
}

Text _text(WidgetTester tester, String value) =>
    tester.widget<Text>(find.text(value));

void main() {
  testWidgets(
    'shows a huge step timer, step name and next step at night colors',
    (tester) async {
      final app = await _startInDistanceView(tester);
      await app.elapse(const Duration(seconds: 3 + 3));

      expect(find.byType(DistanceTimerView), findsOneWidget);
      expect(find.text('01:57'), findsOneWidget);
      expect(find.text('còn lại'), findsOneWidget);
      expect(find.text('Thở tự nhiên'), findsOneWidget);
      expect(find.text('Tiếp theo: Xoay vai nhẹ'), findsOneWidget);
      expect(find.textContaining('Sắp đổi sang'), findsNothing);
      final context = tester.element(find.byType(DistanceTimerView));
      expect(Theme.of(context).appColors, same(AppColors.night));
      expect(_text(tester, '01:57').style!.color, AppColors.night.textPrimary);
      await app.dispose();
    },
  );

  testWidgets('image follows the instruction frames within a step', (
    tester,
  ) async {
    final app = await _startInDistanceView(tester);
    await app.elapse(const Duration(seconds: 3 + 31)); // E01: 4 frames / 120 s
    expect(
      find.byWidgetPredicate(
        (w) =>
            w is Image &&
            w.semanticLabel == 'Đặt tay lên bụng nếu thấy dễ chịu.',
      ),
      findsOneWidget,
    );
    await app.dispose();
  });

  testWidgets('draft media keeps its unreviewed label in distance view (P03)', (
    tester,
  ) async {
    final app = await pumpTestApp(
      tester,
      preferences: _distance,
      manifest: draftManifest(),
    );
    await openPlayerFromHome(tester);
    expect(find.text('Hình minh họa AI chưa kiểm duyệt'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('countdown shows the 3-2-1 digits', (tester) async {
    final app = await _startInDistanceView(tester);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('còn lại'), findsNothing);
    await app.dispose();
  });

  testWidgets('last 10 seconds warn in words and color before the next step', (
    tester,
  ) async {
    final app = await _startInDistanceView(tester);
    await app.elapse(const Duration(seconds: 3 + 112)); // 8 s left in step 1

    expect(find.text('Sắp đổi sang: Xoay vai nhẹ'), findsOneWidget);
    expect(_text(tester, '00:08').style!.color, AppColors.night.warning);
    // The warning sits right under the digits, never below the fold.
    final screen = Offset.zero & tester.view.physicalSize / 3;
    expect(
      screen.contains(
        tester.getRect(find.text('Sắp đổi sang: Xoay vai nhẹ')).bottomCenter,
      ),
      isTrue,
    );
    await app.elapse(const Duration(seconds: 8)); // now step 2
    expect(find.text('Xoay vai nhẹ'), findsOneWidget);
    expect(find.textContaining('Sắp đổi sang'), findsNothing);
    await app.dispose();
  });

  testWidgets('the final step announces the end of the session', (
    tester,
  ) async {
    final app = await _startInDistanceView(tester);
    await app.elapse(const Duration(seconds: 3));
    await tester.tap(find.byTooltip('Bước tiếp'));
    await tester.pump();
    await tester.tap(find.byTooltip('Bước tiếp'));
    await tester.pump();
    await app.elapse(const Duration(seconds: 112));

    expect(find.text('Sắp kết thúc bài'), findsOneWidget);
    expect(find.textContaining('Tiếp theo:'), findsNothing);
    await app.dispose();
  });

  testWidgets('big pause button pauses and resumes', (tester) async {
    final app = await _startInDistanceView(tester);
    await app.elapse(const Duration(seconds: 3 + 2));

    final pause = find.widgetWithText(FilledButton, 'Tạm dừng');
    expect(tester.getSize(pause).height, greaterThanOrEqualTo(72));
    await tester.tap(pause);
    await tester.pump();
    expect(find.text('Đang tạm dừng.'), findsOneWidget);
    await app.elapse(const Duration(minutes: 1));
    expect(find.text('01:58'), findsOneWidget); // frozen
    await tester.tap(
      find.descendant(of: find.byType(Dialog), matching: find.text('Tiếp tục')),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    expect(find.widgetWithText(FilledButton, 'Tạm dừng'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('captions off hides the instruction but keeps the timer', (
    tester,
  ) async {
    final app = await _startInDistanceView(
      tester,
      preferences: const Preferences(
        onboardingCompleted: true,
        captionsEnabled: false,
      ),
    );
    await app.elapse(const Duration(seconds: 4));
    expect(find.text('Ngồi vững, vai và hàm thả lỏng.'), findsNothing);
    expect(find.text('01:59'), findsOneWidget);
    await app.dispose();
  });

  group('motion', () {
    testWidgets('ring animates and breathes while playing, rests when paused', (
      tester,
    ) async {
      final app = await _startInDistanceView(tester);
      await app.elapse(const Duration(seconds: 5));
      expect(tester.binding.transientCallbackCount, greaterThan(0));

      await tester.tap(find.widgetWithText(FilledButton, 'Tạm dừng'));
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 250));
      }
      expect(tester.binding.transientCallbackCount, 0);
      await app.dispose();
    });

    testWidgets('reduced motion: no animation while playing', (tester) async {
      final app = await _startInDistanceView(
        tester,
        preferences: const Preferences(
          onboardingCompleted: true,
          reducedMotion: true,
        ),
      );
      await app.elapse(const Duration(seconds: 5));
      await app.elapse(const Duration(seconds: 1));
      expect(find.text('01:57'), findsOneWidget); // still updates every second
      expect(tester.binding.transientCallbackCount, 0);
      await app.dispose();
    });
  });

  group('status is visible without scrolling (L-008)', () {
    for (final (name, size) in [
      ('360x780', Size(1080, 2340)),
      ('320x568', Size(960, 1704)),
    ]) {
      testWidgets('paused and interrupted messages on $name', (tester) async {
        final app = await _startInDistanceView(tester);
        tester.view.physicalSize = size;
        await app.elapse(const Duration(seconds: 3 + 30));

        void expectOnScreen(String text) {
          final screen = Offset.zero & tester.view.physicalSize / 3;
          final rect = tester.getRect(find.text(text));
          expect(screen.contains(rect.topCenter), isTrue, reason: text);
          expect(screen.contains(rect.bottomCenter), isTrue, reason: text);
        }

        await tester.tap(find.widgetWithText(FilledButton, 'Tạm dừng'));
        await tester.pump();
        expectOnScreen('Đang tạm dừng.');
        expect(find.text('còn lại'), findsNothing);

        await tester.tap(
          find.descendant(
            of: find.byType(Dialog),
            matching: find.text('Tiếp tục'),
          ),
        );
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump();
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.inactive,
        );
        await tester.pump();
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        await tester.pump();
        expectOnScreen(
          'Đã tạm dừng vì ứng dụng bị gián đoạn. Bấm Tiếp tục khi sẵn sàng.',
        );
        await app.dispose();
      });
    }
  });

  testWidgets('the distance view is the only player layout', (tester) async {
    final app = await _startInDistanceView(tester);
    expect(find.byType(DistanceTimerView), findsOneWidget);
    expect(find.text('Xem từ xa'), findsNothing);
    expect(find.text('Chế độ thường'), findsNothing);
    await app.dispose();
  });

  testWidgets('Bát Đoạn Cẩm (R101) plays with its step photos (D13)', (
    tester,
  ) async {
    final app = await pumpTestApp(tester);
    final context = tester.element(find.byType(AnNhienApp));
    ProviderScope.containerOf(context)
        .read(appRouterProvider)
        .go(AppRoutes.session('R101'));
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await settleIo(tester);
    await app.elapse(const Duration(seconds: 4));

    expect(find.text('Hai tay nâng trời'), findsOneWidget);
    expect(find.text('Bước 1 / 8'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is Image && (w.image as AssetImage).assetName == 'packages/an_nhien_eastern_content/assets/series/E101/04_step_1.webp',
      ),
      findsOneWidget,
    );
    await app.dispose();
  });
}
