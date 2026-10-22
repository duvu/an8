import 'break_reminder.dart';

/// Asks the OS only when the user turns a reminder on (PRD F01/F05).
abstract interface class NotificationPermission {
  Future<bool> requestPermission();
}

abstract interface class DailyReminderScheduler {
  Future<void> scheduleDaily(
    int minutesOfDay, {
    required String title,
    required String body,
  });
  Future<void> cancel();
}

abstract interface class BreakReminderScheduler {
  /// Replaces every repeating break reminder with one per entry of
  /// [minutesOfDay]; [bodies] are used in turn so the text varies.
  Future<void> scheduleBreaks(
    List<int> minutesOfDay, {
    required String title,
    required List<String> bodies,
    required BreakAlert alert,
  });
  Future<void> cancelBreaks();
}
