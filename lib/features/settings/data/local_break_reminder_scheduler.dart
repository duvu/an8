import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../domain/break_reminder.dart';
import '../domain/reminder_scheduler.dart';
import 'notification_gateway.dart';

/// Local "stand up and move" reminders (D24): one repeating notification per
/// slot, ids from [_idBase]. Android fixes sound and vibration per channel, so
/// each [BreakAlert] has its own channel.
final class LocalBreakReminderScheduler implements BreakReminderScheduler {
  const LocalBreakReminderScheduler(this._gateway);

  static const _idBase = 100;

  final NotificationGateway _gateway;

  @override
  Future<void> scheduleBreaks(
    List<int> minutesOfDay, {
    required String title,
    required List<String> bodies,
    required BreakAlert alert,
  }) async {
    await cancelBreaks();
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'break_reminder_${alert.name}',
        'Nhắc đứng dậy vận động',
        playSound: alert == BreakAlert.sound,
        enableVibration: alert != BreakAlert.silent,
        importance: alert == BreakAlert.silent
            ? Importance.low
            : Importance.high,
      ),
      iOS: DarwinNotificationDetails(presentSound: alert == BreakAlert.sound),
    );
    for (final (i, minutes) in minutesOfDay.indexed) {
      await _gateway.plugin.zonedSchedule(
        id: _idBase + i,
        scheduledDate: _gateway.nextOccurrence(minutes),
        title: title,
        body: bodies[i % bodies.length],
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  @override
  Future<void> cancelBreaks() async {
    await _gateway.ensureInitialized();
    for (var i = 0; i < maxBreakReminders; i++) {
      await _gateway.plugin.cancel(id: _idBase + i);
    }
  }
}
