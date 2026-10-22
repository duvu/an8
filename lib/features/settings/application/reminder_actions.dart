import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local_break_reminder_scheduler.dart';
import '../data/local_daily_reminder_scheduler.dart';
import '../data/notification_gateway.dart';
import '../domain/break_reminder.dart';
import '../domain/preferences.dart';
import '../domain/reminder_scheduler.dart';
import 'preferences_controller.dart';

final notificationGatewayProvider = Provider<NotificationGateway>(
  (ref) => NotificationGateway(),
);

final notificationPermissionProvider = Provider<NotificationPermission>(
  (ref) => ref.watch(notificationGatewayProvider),
);

final dailyReminderSchedulerProvider = Provider<DailyReminderScheduler>(
  (ref) => LocalDailyReminderScheduler(ref.watch(notificationGatewayProvider)),
);

final breakReminderSchedulerProvider = Provider<BreakReminderScheduler>(
  (ref) => LocalBreakReminderScheduler(ref.watch(notificationGatewayProvider)),
);

enum ReminderResult { scheduled, cancelled, permissionDenied, invalidWindow }

final reminderActionsProvider = Provider<ReminderActions>(ReminderActions.new);

/// Turns the reminders on/off and keeps the saved settings in step with what
/// was actually scheduled. Permission is requested only when enabling.
final class ReminderActions {
  ReminderActions(this._ref);

  final Ref _ref;

  Future<void> _save(Preferences Function(Preferences) change) =>
      _ref.read(preferencesProvider.notifier).update(change);

  /// Permission, then [schedule], then [saveOn]; a refusal saves [saveOff].
  Future<ReminderResult> _enable({
    required Future<void> Function() schedule,
    required Preferences Function(Preferences) saveOn,
    required Preferences Function(Preferences) saveOff,
  }) async {
    if (!await _ref.read(notificationPermissionProvider).requestPermission()) {
      await _save(saveOff);
      return ReminderResult.permissionDenied;
    }
    await schedule();
    await _save(saveOn);
    return ReminderResult.scheduled;
  }

  Future<ReminderResult> setDaily({
    required bool enabled,
    required int minutesOfDay,
    required String title,
    required String body,
  }) async {
    final scheduler = _ref.read(dailyReminderSchedulerProvider);
    if (!enabled) {
      await scheduler.cancel();
      await _save((p) => p.copyWith(reminderEnabled: false));
      return ReminderResult.cancelled;
    }
    return _enable(
      schedule: () =>
          scheduler.scheduleDaily(minutesOfDay, title: title, body: body),
      saveOn: (p) =>
          p.copyWith(reminderEnabled: true, reminderMinutes: minutesOfDay),
      saveOff: (p) => p.copyWith(reminderEnabled: false),
    );
  }

  /// The new settings are saved even when they cannot be scheduled
  /// ([ReminderResult.invalidWindow]), but the reminder stays off.
  Future<ReminderResult> setBreaks({
    required bool enabled,
    required int intervalMinutes,
    required int startMinutes,
    required int endMinutes,
    required BreakAlert alert,
    required String title,
    required List<String> bodies,
  }) async {
    final scheduler = _ref.read(breakReminderSchedulerProvider);
    Preferences Function(Preferences) apply({required bool on}) =>
        (p) => p.copyWith(
          breakReminderEnabled: on,
          breakIntervalMinutes: intervalMinutes,
          breakStartMinutes: startMinutes,
          breakEndMinutes: endMinutes,
          breakAlert: alert,
        );
    final times = enabled
        ? breakReminderTimes(
            startMinutes: startMinutes,
            endMinutes: endMinutes,
            intervalMinutes: intervalMinutes,
          )
        : const <int>[];
    if (!enabled || times.isEmpty) {
      await scheduler.cancelBreaks();
      await _save(apply(on: false));
      return enabled ? ReminderResult.invalidWindow : ReminderResult.cancelled;
    }
    return _enable(
      schedule: () => scheduler.scheduleBreaks(
        times,
        title: title,
        bodies: bodies,
        alert: alert,
      ),
      saveOn: apply(on: true),
      saveOff: apply(on: false),
    );
  }
}
