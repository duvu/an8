import 'package:an_nhien/app/app.dart';
import 'package:an_nhien/features/settings/domain/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'fakes.dart';

final class TestApp {
  TestApp(this.tester, this.db, this.clock, this.preloader);

  final WidgetTester tester;
  final Database db;
  final FakeClock clock;
  final FakeMediaPreloader preloader;

  /// Advances the fake monotonic clock and lets refresh timers fire.
  Future<void> elapse(Duration d) async {
    clock.advance(d);
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pump();
  }

  /// Unmounts the app so periodic timers are cancelled before the test ends.
  Future<void> dispose() async {
    await tester.pumpWidget(const SizedBox());
    await db.close();
  }
}

Future<TestApp> pumpTestApp(
  WidgetTester tester, {
  List<Override> extra = const [],
  FakeMediaPreloader? preloader,
  Preferences preferences = const Preferences(onboardingCompleted: true),
  FakeReminderScheduler? reminders,
  bool splash = false,
  String? manifest,
  bool allowPreviewContent = true,
  FakeCuePlayer? cues,
  FakeMusicPlayer? music,
  FakeFileSharer? sharer,
}) async {
  // Cached asset futures from a previous test's fake-async zone never complete.
  rootBundle.clear();
  // Typical phone: 360 x 780 dp.
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final db = (await tester.runAsync(openTestDatabase))!;
  // A failing test never reaches app.dispose(); without this the shared
  // in-memory database leaks into the next test (L-015).
  addTearDown(() async {
    if (db.isOpen) await db.close();
  });
  final clock = FakeClock();
  final media = preloader ?? FakeMediaPreloader();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...testOverrides(
          db: db,
          clock: clock,
          preloader: media,
          preferences: preferences,
          reminders: reminders,
          splash: splash,
          manifest: manifest,
          allowPreviewContent: allowPreviewContent,
          cues: cues,
          music: music,
          sharer: sharer,
        ),
        ...extra,
      ],
      child: const AnNhienApp(),
    ),
  );
  await tester.pumpAndSettle();
  return TestApp(tester, db, clock, media);
}

/// Runs real async work (sqlite I/O) and then rebuilds.
Future<void> settleIo(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 20)),
  );
  await tester.pump();
  await tester.pump();
}

/// The main vertical list of [screen] (filter rows add horizontal scrollables).
Finder mainScrollable(Type screen) => find
    .descendant(of: find.byType(screen), matching: find.byType(Scrollable))
    .first;

/// Home → Preflight → Player, ready for the countdown.
Future<void> openPlayerFromHome(WidgetTester tester) async {
  final start = find.widgetWithText(FilledButton, 'Bắt đầu');
  await tester.ensureVisible(start);
  await tester.pumpAndSettle();
  await tester.tap(start);
  await tester.pumpAndSettle();
  expect(find.text('Trước khi tập'), findsOneWidget);
  await tester.tap(find.text('Tôi đã đọc, bắt đầu'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  await settleIo(tester);
}

/// Bounded settling for screens that load real assets or keep animating:
/// pumpAndSettle would time out while a loading spinner spins.
Future<void> settleScreen(WidgetTester tester) async {
  for (var i = 0; i < 4; i++) {
    await tester.pump(const Duration(milliseconds: 150));
    await settleIo(tester);
  }
}

/// Pumps (with real I/O) until [finder] matches, for screens that read several
/// asset files in sequence. Fails after [maxRounds].
Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  int maxRounds = 30,
}) async {
  for (var i = 0; i < maxRounds; i++) {
    if (finder.evaluate().isNotEmpty) return;
    await tester.pump(const Duration(milliseconds: 100));
    await settleIo(tester);
  }
  expect(finder, findsWidgets);
}
