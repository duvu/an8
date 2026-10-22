import '../../../app/localization/generated/app_localizations.dart';
import '../domain/day_activities.dart';
import '../domain/day_almanac.dart';
import '../domain/lunar_mansions.dart';

extension CalendarLabels on AppLocalizations {
  /// [weekday] follows [DateTime.weekday]: 1 = Monday … 7 = Sunday.
  String weekdayShort(int weekday) => switch (weekday) {
    1 => calendarWeekdayShort1,
    2 => calendarWeekdayShort2,
    3 => calendarWeekdayShort3,
    4 => calendarWeekdayShort4,
    5 => calendarWeekdayShort5,
    6 => calendarWeekdayShort6,
    _ => calendarWeekdayShort7,
  };

  String weekdayFull(int weekday) => switch (weekday) {
    1 => calendarWeekdayFull1,
    2 => calendarWeekdayFull2,
    3 => calendarWeekdayFull3,
    4 => calendarWeekdayFull4,
    5 => calendarWeekdayFull5,
    6 => calendarWeekdayFull6,
    _ => calendarWeekdayFull7,
  };

  String ratingText(DayRating rating) => switch (rating) {
    DayRating.good => calendarRatingGood,
    DayRating.neutral => calendarRatingNeutral,
    DayRating.bad => calendarRatingBad,
  };

  String mansionLevelText(MansionLevel level) => switch (level) {
    MansionLevel.kiet => calendarMansionKiet,
    MansionLevel.binh => calendarMansionBinh,
    MansionLevel.hung => calendarMansionHung,
  };

  String activityName(Activity a) => switch (a) {
    Activity.wedding => calendarActivityWedding,
    Activity.opening => calendarActivityOpening,
    Activity.building => calendarActivityBuilding,
    Activity.departure => calendarActivityDeparture,
    Activity.burial => calendarActivityBurial,
    Activity.lawsuit => calendarActivityLawsuit,
  };

  String verdictText(Verdict v) => switch (v) {
    Verdict.favorable => calendarVerdictFavorable,
    Verdict.neutral => calendarVerdictNeutral,
    Verdict.unfavorable => calendarVerdictUnfavorable,
  };

  /// "Thuận: Trực Khai" / "Ngược: ngày hắc đạo (Thiên Lao)".
  String evidenceText(Evidence e, DayAlmanac day) {
    final what = switch (e.source) {
      EvidenceSource.hoangDao =>
        day.isHoangDao
            ? calendarWhatHoangDao(e.name)
            : calendarWhatHacDao(e.name),
      EvidenceSource.truc => calendarWhatTruc(e.name),
      EvidenceSource.mansion => calendarWhatMansion(e.name),
      EvidenceSource.lucDieu => calendarWhatLucDieu(e.name),
    };
    return e.favorable
        ? calendarEvidenceFor(what)
        : calendarEvidenceAgainst(what);
  }

  String dayKind(DayAlmanac a) =>
      a.isHoangDao ? calendarHoangDao : calendarHacDao;

  /// What a screen reader says for one cell of the month grid.
  String cellLabel(DayAlmanac a) => calendarCellLabel(
    weekdayFull(a.date.weekday),
    a.date.day,
    a.date.month,
    a.date.year,
    a.lunar.day,
    a.lunar.month,
    dayKind(a),
  );
}

String two(int n) => n.toString().padLeft(2, '0');
String hourText(int hour) => '${two(hour)}:00';
