import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/clock/clock_provider.dart';
import '../domain/day_almanac.dart';

/// Years the almanac can compute (see [almanacFor]).
const calendarFirstDate = (year: 1900, month: 1, day: 1);
const calendarLastDate = (year: 2100, month: 12, day: 31);

DateTime get firstSupportedDate => DateTime(
  calendarFirstDate.year,
  calendarFirstDate.month,
  calendarFirstDate.day,
);
DateTime get lastSupportedDate => DateTime(
  calendarLastDate.year,
  calendarLastDate.month,
  calendarLastDate.day,
);

final class CalendarState {
  const CalendarState({required this.month, required this.selected});

  /// First day of the month on show.
  final DateTime month;
  final DateTime selected;
}

final calendarControllerProvider =
    NotifierProvider.autoDispose<CalendarController, CalendarState>(
      CalendarController.new,
    );

/// Which month is on show and which day is selected; starts on today.
class CalendarController extends Notifier<CalendarState> {
  @override
  CalendarState build() => _on(ref.read(appClockProvider).now());

  CalendarState _on(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    return CalendarState(month: DateTime(day.year, day.month), selected: day);
  }

  void goToToday() => state = _on(ref.read(appClockProvider).now());

  /// Selects [date] and shows its month; dates outside the supported range
  /// are ignored.
  void select(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    if (day.isBefore(firstSupportedDate) || day.isAfter(lastSupportedDate)) {
      return;
    }
    state = _on(day);
  }

  /// Moves the month by [delta]; the selection follows to the same day number
  /// (or the last day of a shorter month).
  void moveMonth(int delta) {
    final target = DateTime(state.month.year, state.month.month + delta);
    final lastDay = DateTime(target.year, target.month + 1, 0).day;
    final day = state.selected.day > lastDay ? lastDay : state.selected.day;
    select(DateTime(target.year, target.month, day));
  }
}

/// The days shown for [month]: whole weeks, Monday first.
List<DateTime> monthGridDays(DateTime month) {
  final first = DateTime(month.year, month.month);
  final start = DateTime(first.year, first.month, 1 - (first.weekday - 1));
  final last = DateTime(month.year, month.month + 1, 0);
  final trailing = 7 - last.weekday;
  final end = DateTime(last.year, last.month, last.day + trailing);
  final days = <DateTime>[];
  for (
    var d = start;
    !d.isAfter(end);
    d = DateTime(d.year, d.month, d.day + 1)
  ) {
    days.add(d);
  }
  return days;
}

/// Almanac of every day in the grid of [month] (a first-of-month date).
final monthAlmanacProvider = Provider.family<List<DayAlmanac>, DateTime>(
  (ref, month) => [for (final d in monthGridDays(month)) almanacFor(d)],
);
