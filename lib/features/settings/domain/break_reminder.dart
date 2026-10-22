/// Intervals offered for "stand up and move" reminders, in minutes.
const breakIntervalOptions = [45, 60, 90, 120];

/// How a break reminder alerts the user. Android fixes sound and vibration per
/// notification channel, so each value maps to its own channel; iOS has no
/// vibration switch and treats [vibrate] like [silent].
enum BreakAlert { silent, vibrate, sound }

const defaultBreakAlert = BreakAlert.vibrate;
const defaultBreakIntervalMinutes = 60;
const defaultBreakStartMinutes = 8 * 60;
const defaultBreakEndMinutes = 18 * 60;

/// Upper bound of reminders in one day (24 h at the shortest interval); the
/// scheduler reserves this many notification ids.
const maxBreakReminders = 24 * 60 ~/ 45;

/// Minutes after midnight of each reminder in `[start, end]`: the first one an
/// [interval] after [start] (the user has been sitting since then), the last
/// one not after [end]. Empty when the window is shorter than one interval.
List<int> breakReminderTimes({
  required int startMinutes,
  required int endMinutes,
  required int intervalMinutes,
}) {
  if (intervalMinutes <= 0) return const [];
  final times = <int>[];
  for (
    var t = startMinutes + intervalMinutes;
    t <= endMinutes && t < 24 * 60 && times.length < maxBreakReminders;
    t += intervalMinutes
  ) {
    times.add(t);
  }
  return times;
}
