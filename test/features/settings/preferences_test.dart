import 'package:an_nhien/features/catalog/domain/catalog_models.dart';
import 'package:an_nhien/features/settings/application/preferences_controller.dart';
import 'package:an_nhien/features/settings/application/reminder_actions.dart';
import 'package:an_nhien/features/settings/data/sqlite_preferences_repository.dart';
import 'package:an_nhien/features/settings/domain/preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../support/fakes.dart';

void main() {
  late Database db;
  late SqlitePreferencesRepository repo;

  setUp(() async {
    db = await openTestDatabase();
    addTearDown(db.close);
    repo = SqlitePreferencesRepository(db);
  });

  test('defaults when nothing is stored', () async {
    final p = await repo.load();
    expect(p.onboardingCompleted, isFalse);
    expect(p.captionsEnabled, isTrue);
    expect(p.soundCues, isTrue);
    expect(p.backgroundMusic, isTrue);
    expect(p.reminderMinutes, Preferences.defaultReminderMinutes);
  });

  test('round-trips every field and clears nullable ones', () async {
    await repo.save(
      const Preferences(
        onboardingCompleted: true,
        position: BodyPosition.seated,
        goalTag: 'evening',
        captionsEnabled: false,
        reducedMotion: true,
        soundCues: false,
        backgroundMusic: false,
        reminderEnabled: true,
        reminderMinutes: 1290,
      ),
    );
    var p = await repo.load();
    expect(p.position, BodyPosition.seated);
    expect(p.goalTag, 'evening');
    expect(p.captionsEnabled, isFalse);
    expect(p.reducedMotion, isTrue);
    expect(p.soundCues, isFalse);
    expect(p.backgroundMusic, isFalse);
    expect(p.reminderEnabled, isTrue);
    expect(p.reminderMinutes, 1290);

    await repo.save(p.copyWith(position: () => null, goalTag: () => null));
    p = await repo.load();
    expect(p.position, isNull);
    expect(p.goalTag, isNull);
  });

  test('corrupt values fall back to defaults', () async {
    await db.insert('preferences', {'key': 'position', 'value': 'lying'});
    await db.insert('preferences', {'key': 'reminderMinutes', 'value': 'abc'});
    final p = await repo.load();
    expect(p.position, isNull);
    expect(p.reminderMinutes, Preferences.defaultReminderMinutes);
  });

  group('reminder', () {
    late FakeReminderScheduler scheduler;
    late ProviderContainer container;

    setUp(() {
      scheduler = FakeReminderScheduler();
      container = ProviderContainer(
        overrides: testOverrides(db: db, reminders: scheduler),
      );
      addTearDown(container.dispose);
    });

    Future<ReminderResult> set(bool enabled, [int minutes = 480]) => container
        .read(reminderActionsProvider)
        .setDaily(
          enabled: enabled,
          minutesOfDay: minutes,
          title: 't',
          body: 'b',
        );

    test(
      'asks permission only when enabling, then schedules and persists',
      () async {
        expect(scheduler.permissionRequests, 0);
        expect(await set(true), ReminderResult.scheduled);
        expect(scheduler.permissionRequests, 1);
        expect(scheduler.scheduledMinutes, 480);
        expect(container.read(preferencesProvider).reminderEnabled, isTrue);
        expect((await repo.load()).reminderMinutes, 480);
      },
    );

    test('denied permission leaves the reminder off', () async {
      scheduler.grant = false;
      expect(await set(true), ReminderResult.permissionDenied);
      expect(scheduler.scheduledMinutes, isNull);
      expect(container.read(preferencesProvider).reminderEnabled, isFalse);
    });

    test('disabling cancels without asking permission', () async {
      await set(true);
      expect(await set(false), ReminderResult.cancelled);
      expect(scheduler.permissionRequests, 1);
      expect(scheduler.scheduledMinutes, isNull);
      expect((await repo.load()).reminderEnabled, isFalse);
    });
  });
}
