import 'package:an_nhien/features/catalog/application/catalog_providers.dart';
import 'package:an_nhien/features/catalog/data/media_availability.dart';
import 'package:an_nhien/features/session/data/sqlite_session_repository.dart';
import 'package:an_nhien/features/session/domain/workout_session.dart';
import 'package:an_brand/an_brand.dart';
import 'package:an_nhien/app/theme/app_theme.dart';
import 'package:an_nhien/app/theme/semantic_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';
import '../catalog/catalog_test_data.dart';
import '../../support/test_app.dart';

final class _NoMedia implements MediaAvailability {
  @override
  Future<Set<String>> availablePaths() async => {};
}

Finder inPausePanel(String text) =>
    find.descendant(of: find.byType(Dialog), matching: find.text(text));

Future<List<WorkoutSession>> sessions(TestApp app) async =>
    (await app.tester.runAsync(() => SqliteSessionRepository(app.db).all()))!;

void main() {
  testWidgets(
    'R01 golden path: Home → Preflight → Player → Summary → Progress',
    (tester) async {
      final app = await pumpTestApp(tester);
      await openPlayerFromHome(tester);

      // Countdown first, timers not running.
      expect(find.text('3'), findsOneWidget);
      expect(find.text('Bước 1 / 3'), findsOneWidget);
      expect(find.text('Hình minh họa AI chưa kiểm duyệt'), findsNothing);

      await app.elapse(const Duration(seconds: 3));
      expect(find.text('Thở tự nhiên'), findsOneWidget);
      expect(find.text('Ngồi vững, vai và hàm thả lỏng.'), findsOneWidget);
      expect(find.text('02:00'), findsOneWidget);

      await app.elapse(const Duration(seconds: 125));
      expect(find.text('Bước 2 / 3'), findsOneWidget);
      expect(find.text('Xoay vai nhẹ'), findsOneWidget);

      await app.elapse(const Duration(minutes: 5));
      await tester.pumpAndSettle();
      await settleIo(tester);
      expect(find.text('Hoàn thành bài tập'), findsOneWidget);
      expect(find.text('Thời gian tập thực tế: 6 phút 0 giây'), findsOneWidget);

      final saved = await sessions(app);
      expect(saved.single.status, WorkoutStatus.completed);
      expect(saved.single.activeTime, const Duration(minutes: 6));

      await tester.tap(find.text('Xem tiến độ'));
      await tester.pumpAndSettle();
      await settleIo(tester);
      expect(find.text('1 buổi · 1 hoàn thành'), findsOneWidget);
      await app.dispose();
    },
  );

  testWidgets('draft media is marked as unreviewed in the player (P03)', (
    tester,
  ) async {
    final app = await pumpTestApp(tester, manifest: draftManifest());
    await openPlayerFromHome(tester);

    expect(find.text('Hình minh họa AI chưa kiểm duyệt'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('Tạm dừng opens the pause panel; Dừng hẳn records abandoned', (
    tester,
  ) async {
    final app = await pumpTestApp(tester);
    await openPlayerFromHome(tester);
    await app.elapse(const Duration(seconds: 3 + 30));

    expect(find.text('Dừng'), findsNothing); // no separate Stop button
    await tester.tap(find.widgetWithText(FilledButton, 'Tạm dừng'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    expect(inPausePanel('Đang tạm dừng'), findsOneWidget);
    // Night palette like the player, not the bright app theme.
    expect(
      Theme.of(tester.element(find.byType(Dialog))).appColors,
      same(AppColors.night),
    );
    // Styled by the app's dialog tokens, not Material's default grey.
    final panel = tester.widget<Material>(
      find
          .descendant(of: find.byType(Dialog), matching: find.byType(Material))
          .first,
    );
    expect(panel.color, AppColors.night.surfaceElevated);
    // The scrim is dark too (it came from the light theme before).
    final scrim = tester
        .widgetList<ModalBarrier>(find.byType(ModalBarrier))
        .last;
    expect(scrim.color, AppTheme.night.dialogTheme.barrierColor);
    expect(scrim.color!.computeLuminance(), lessThan(0.05));
    expect(
      find.descendant(of: find.byType(Dialog), matching: find.byType(AnLotus)),
      findsOneWidget,
    );
    await tester.tap(inPausePanel('Dừng hẳn'));
    await tester.pumpAndSettle();
    await settleIo(tester);

    expect(find.text('Đã kết thúc sớm'), findsOneWidget);
    final saved = await sessions(app);
    expect(saved.single.status, WorkoutStatus.abandoned);
    expect(saved.single.activeTime, const Duration(seconds: 30));
    await app.dispose();
  });

  testWidgets('pause panel "Tiếp tục" resumes the session', (tester) async {
    final app = await pumpTestApp(tester);
    await openPlayerFromHome(tester);
    await app.elapse(const Duration(seconds: 5));

    await tester.tap(find.widgetWithText(FilledButton, 'Tạm dừng'));
    await tester.pumpAndSettle();
    await tester.tap(inPausePanel('Tiếp tục'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(Dialog), findsNothing);
    expect(find.widgetWithText(FilledButton, 'Tạm dừng'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('dismissing the pause panel keeps the session paused', (
    tester,
  ) async {
    final app = await pumpTestApp(tester);
    await openPlayerFromHome(tester);
    await app.elapse(const Duration(seconds: 5));

    await tester.tap(find.widgetWithText(FilledButton, 'Tạm dừng'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10)); // barrier
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await app.elapse(const Duration(minutes: 1));

    expect(find.byType(Dialog), findsNothing);
    expect(find.text('Đang tạm dừng.'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Tiếp tục'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('back from an interruption shows the pause panel', (
    tester,
  ) async {
    final app = await pumpTestApp(tester);
    await openPlayerFromHome(tester);
    await app.elapse(const Duration(seconds: 10));

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await app.elapse(const Duration(minutes: 1));

    expect(find.byType(Dialog), findsOneWidget);
    expect(
      find.text(
        'Đã tạm dừng vì ứng dụng bị gián đoạn. Bấm Tiếp tục khi sẵn sàng.',
      ),
      findsOneWidget,
    );
    expect(find.text('01:53'), findsOneWidget); // 7s played, frozen
    await tester.tap(inPausePanel('Tiếp tục'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.widgetWithText(FilledButton, 'Tạm dừng'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('media failure shows Retry / Skip and never completes', (
    tester,
  ) async {
    final app = await pumpTestApp(
      tester,
      preloader: FakeMediaPreloader(succeed: false),
    );
    await openPlayerFromHome(tester);

    expect(find.text('Không tải được hình hướng dẫn.'), findsOneWidget);
    expect(find.text('Bỏ qua bước'), findsOneWidget);
    await app.elapse(const Duration(minutes: 10));
    expect(find.text('Hoàn thành bài tập'), findsNothing);

    app.preloader.succeed = true;
    await tester.tap(find.widgetWithText(FilledButton, 'Thử lại'));
    await tester.pump();
    await tester.pump();
    expect(find.text('3'), findsOneWidget); // countdown, never played before
    await app.dispose();
  });

  testWidgets(
    'detail shows "Cần tải" instead of a broken Start without media',
    (tester) async {
      final app = await pumpTestApp(
        tester,
        extra: [mediaAvailabilityProvider.overrideWithValue(_NoMedia())],
      );
      await tester.tap(find.text('Khởi động nhẹ'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Cần tải'), 200);

      final button = tester.widget<ButtonStyleButton>(
        find.ancestor(
          of: find.text('Cần tải'),
          matching: find.bySubtype<ButtonStyleButton>(),
        ),
      );
      expect(button.onPressed, isNull);
      expect(find.text('Bắt đầu bài tập'), findsNothing);
      await app.dispose();
    },
  );
}
