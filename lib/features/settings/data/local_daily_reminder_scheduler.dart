import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../domain/reminder_scheduler.dart';
import 'notification_gateway.dart';

/// Local-only daily practice reminder. Inexact alarms: no exact-alarm
/// permission is needed, but Android may deliver up to ~1 hour late (window
/// seen on API 35 emulator: +1h). See TRACKER T19 note.
final class LocalDailyReminderScheduler implements DailyReminderScheduler {
  const LocalDailyReminderScheduler(this._gateway);

  static const _notificationId = 1;
  static const _channelId = 'daily_reminder';
  static const _channelName = 'Nhắc nhở tập';

  final NotificationGateway _gateway;

  @override
  Future<void> scheduleDaily(
    int minutesOfDay, {
    required String title,
    required String body,
  }) async {
    await _gateway.ensureInitialized();
    await _gateway.plugin.zonedSchedule(
      id: _notificationId,
      scheduledDate: _gateway.nextOccurrence(minutesOfDay),
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(_channelId, _channelName),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> cancel() async {
    await _gateway.ensureInitialized();
    await _gateway.plugin.cancel(id: _notificationId);
  }
}
