import 'package:an_nhien/features/settings/application/preferences_controller.dart';
import 'package:an_nhien/features/settings/application/reminder_actions.dart';
import 'package:an_nhien/features/settings/data/sqlite_preferences_repository.dart';
import 'package:an_nhien/features/settings/domain/break_reminder.dart';
import 'package:an_nhien/features/settings/presentation/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../support/fakes.dart';
import '../../support/test_app.dart';

void main() {
  group('breakReminderTimes', () {
    test('first reminder one interval after start, last not after end', () {
      expect(
        breakReminderTimes(
          startMinutes: 8 * 60,
          endMinutes: 11 * 60,
          intervalMinutes: 60,
        ),
        [9 * 60, 10 * 60, 11 * 60],
      );
    });

    test('window shorter than one interval gives none', () {
      expect(
        breakReminderTimes(
          startMinutes: 8 * 60,
          endMinutes: 8 * 60 + 30,
          intervalMinutes: 45,
        ),
        isEmpty,
      );
    });

    test('never reaches midnight or exceeds the reserved id range', () {
      final t = breakReminderTimes(
        startMinutes: 0,
        endMinutes: 24 * 60,
        intervalMinutes: 45,
      );
      expect(t.length, lessThanOrEqualTo(maxBreakReminders));
      expect(t.last, lessThan(24 * 60));
    });
  });

  group('controller', () {
    late Database db;
    late FakeReminderScheduler scheduler;
    late ProviderContainer container;

    setUp(() async {
      db = await openTestDatabase();
      addTearDown(db.close);
      scheduler = FakeReminderScheduler();
      container = ProviderContainer(
        overrides: testOverrides(db: db, reminders: scheduler),
      );
      addTearDown(container.dispose);
    });

    Future<ReminderResult> set({
      bool enabled = true,
      int end = 12 * 60,
      BreakAlert alert = BreakAlert.sound,
    }) => container
        .read(reminderActionsProvider)
        .setBreaks(
          enabled: enabled,
          intervalMinutes: 60,
          startMinutes: 8 * 60,
          endMinutes: end,
          alert: alert,
          title: 't',
          bodies: const ['b'],
        );

    test('schedules, remembers alert type and persists', () async {
      expect(await set(), ReminderResult.scheduled);
      expect(scheduler.breakTimes, [540, 600, 660, 720]);
      expect(scheduler.breakAlert, BreakAlert.sound);
      final saved = await SqlitePreferencesRepository(db).load();
      expect(saved.breakReminderEnabled, isTrue);
      expect(saved.breakAlert, BreakAlert.sound);
      expect(saved.breakEndMinutes, 12 * 60);
    });

    test('empty window stays off and cancels', () async {
      await set();
      expect(await set(end: 8 * 60 + 10), ReminderResult.invalidWindow);
      expect(scheduler.breakTimes, isEmpty);
      expect(container.read(preferencesProvider).breakReminderEnabled, isFalse);
    });

    test('denied permission leaves it off', () async {
      scheduler.grant = false;
      expect(await set(), ReminderResult.permissionDenied);
      expect(scheduler.breakTimes, isEmpty);
    });

    test('disabling cancels', () async {
      await set();
      expect(await set(enabled: false), ReminderResult.cancelled);
      expect(scheduler.breakTimes, isEmpty);
    });

    test('corrupt alert falls back to default', () async {
      await db.insert('preferences', {'key': 'breakAlert', 'value': 'loud'});
      expect(
        (await SqlitePreferencesRepository(db).load()).breakAlert,
        defaultBreakAlert,
      );
    });
  });

  testWidgets('changing type and interval reschedules while enabled', (
    tester,
  ) async {
    final reminders = FakeReminderScheduler();
    final app = await pumpTestApp(tester, reminders: reminders);
    await tester.tap(find.text('Cài đặt'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Nhắc đứng dậy vận động'),
      100,
      scrollable: mainScrollable(SettingsScreen),
    );
    await tester.drag(mainScrollable(SettingsScreen), const Offset(0, -100));
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(SwitchListTile, 'Nhắc đứng dậy vận động'),
    );
    await tester.pump();
    await settleIo(tester);
    expect(reminders.breakTimes.length, 10);
    expect(reminders.breakAlert, BreakAlert.vibrate);

    await tester.scrollUntilVisible(
      find.text('Chuông'),
      100,
      scrollable: mainScrollable(SettingsScreen),
    );
    await tester.drag(mainScrollable(SettingsScreen), const Offset(0, -100));
    await tester.pumpAndSettle();
    await tester.drag(mainScrollable(SettingsScreen), const Offset(0, -100));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Chuông'));
    await tester.pump();
    await settleIo(tester);
    expect(reminders.breakAlert, BreakAlert.sound);

    await tester.scrollUntilVisible(
      find.text('120 phút'),
      -100,
      scrollable: mainScrollable(SettingsScreen),
    );
    await tester.drag(mainScrollable(SettingsScreen), const Offset(0, 100));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, '120 phút'));
    await tester.pump();
    await settleIo(tester);
    expect(reminders.breakTimes, [10 * 60, 12 * 60, 14 * 60, 16 * 60, 18 * 60]);
    await app.dispose();
  });
}
