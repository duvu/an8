import 'almanac_tables.dart';
import 'lunar_calendar.dart';
import 'lunar_mansions.dart';
import 'sexagenary.dart';

enum DayRating { good, neutral, bad }

/// One of the 12 double-hours (giờ) of a day.
final class HourInfo {
  const HourInfo({
    required this.chi,
    required this.god,
    required this.isHoangDao,
    required this.lucDieu,
  });

  /// 0 = Tý (23:00–01:00) … 11 = Hợi.
  final int chi;

  /// Index into [twelveGods].
  final int god;
  final bool isHoangDao;

  /// Index into [lucDieu] for this hour (Lý Thuần Phong, fixed by the hour).
  final int lucDieu;

  String get name => chiNames[chi];
  int get startHour => (23 + 2 * chi) % 24;
  int get endHour => (startHour + 2) % 24;
  String get godName => twelveGods[god];
  bool get isGoodForDeparture =>
      isHoangDao && lucDieuInfoAt(lucDieu).level == LucDieuLevel.good;
}

LucDieuInfo lucDieuInfoAt(int index) => lucDieu[index];

/// Everything the almanac says about one civil day.
final class DayAlmanac {
  const DayAlmanac({
    required this.date,
    required this.lunar,
    required this.dayCanChi,
    required this.monthCanChi,
    required this.yearCanChi,
    required this.solarTerm,
    required this.termStartsToday,
    required this.truc,
    required this.god,
    required this.isHoangDao,
    required this.hours,
    required this.lucDieuDay,
    required this.hyThan,
    required this.taiThan,
    required this.rating,
    required this.mansion,
  });

  final DateTime date;
  final LunarDate lunar;
  final CanChi dayCanChi;
  final CanChi monthCanChi;
  final CanChi yearCanChi;

  /// Tiết khí in force on this day; [termStartsToday] when it begins today.
  final String solarTerm;
  final bool termStartsToday;

  /// Index into [trucNames] / [trucInfo].
  final int truc;

  /// Index into [twelveGods]: the god ruling the day.
  final int god;
  final bool isHoangDao;

  /// The 12 hours from Tý, in order.
  final List<HourInfo> hours;

  /// Index into [lucDieu] for the whole day (Khổng Minh, by lunar date).
  final int lucDieuDay;
  final String hyThan;
  final String taiThan;
  final DayRating rating;

  /// Index into [lunarMansions]: the sao (nhị thập bát tú) ruling the day.
  final int mansion;

  LunarMansion get mansionDetail => lunarMansions[mansion];
  String get trucName => trucNames[truc];
  TrucInfo get trucDetail => trucInfo[truc];
  String get godName => twelveGods[god];
  LucDieuInfo get lucDieuDayInfo => lucDieu[lucDieuDay];
  List<HourInfo> get hoangDaoHours => [
    for (final h in hours)
      if (h.isHoangDao) h,
  ];
  List<HourInfo> get departureHours => [
    for (final h in hours)
      if (h.isGoodForDeparture) h,
  ];

  bool get isFirstOfLunarMonth => lunar.day == 1;
  bool get isFullMoon => lunar.day == 15;
}

int _mod(int a, int n) => ((a % n) + n) % n;

/// Where the 12 gods start for a [chi]: Dần/Thân → Tý, Mão/Dậu → Dần,
/// Thìn/Tuất → Thìn, Tỵ/Hợi → Ngọ, Tý/Ngọ → Thân, Sửu/Mùi → Tuất. For days
/// [chi] is the month's (tiết) branch; for hours it is the day's branch.
int _godsStart(int chi) => _mod(chi - 2, 6) * 2;

/// Day, month, year, hours, trực and xuất hành data for [date] (time of day
/// ignored). Valid for the Gregorian years 1900–2199.
DayAlmanac almanacFor(DateTime date) {
  final jd = julianDayNumber(date.year, date.month, date.day);
  final lunar = solarToLunar(date);
  final dayPair = dayCanChi(jd);
  final yearPair = yearCanChi(lunar.year);

  // Month by tiết (jie): it changes ON the day the sun reaches 315°, 345°, …
  final longitudeStart = sunLongitudeDegrees(jd);
  final longitudeEnd = sunLongitudeDegrees(jd + 1);
  final sector = (_mod((longitudeEnd - 315).floor(), 360) / 30).floor();
  final jieMonthChi = _mod(2 + sector, 12);

  final truc = _mod(dayPair.chi - jieMonthChi, 12);
  final godOfDay = _mod(dayPair.chi - _godsStart(jieMonthChi), 12);
  final isHoangDao = hoangDaoOffsets.contains(godOfDay);

  // Khổng Minh lục diệu of the day counts from the lunar month and day; the
  // hours follow Lý Thuần Phong (fixed: Tý/Ngọ Đại An, Sửu/Mùi Lưu Liên, ...).
  final lucDieuDay = _mod(lunar.month + lunar.day - 1, 6);
  final hourStart = _godsStart(dayPair.chi);
  final hours = [
    for (var chi = 0; chi < 12; chi++)
      HourInfo(
        chi: chi,
        god: _mod(chi - hourStart, 12),
        isHoangDao: hoangDaoOffsets.contains(_mod(chi - hourStart, 12)),
        lucDieu: chi % 6,
      ),
  ];

  final termIndex = (longitudeEnd / 15).floor() % 24;
  final trucLevel = trucInfo[truc].level;
  final score =
      (isHoangDao ? 1 : -1) +
      switch (trucLevel) {
        TrucLevel.good => 1,
        TrucLevel.neutral => 0,
        TrucLevel.bad => -1,
      };

  return DayAlmanac(
    date: DateTime(date.year, date.month, date.day),
    lunar: lunar,
    dayCanChi: dayPair,
    monthCanChi: monthCanChi(yearPair.can, lunar.month),
    yearCanChi: yearPair,
    solarTerm: solarTermNames[termIndex],
    termStartsToday:
        (longitudeStart / 15).floor() != (longitudeEnd / 15).floor(),
    truc: truc,
    god: godOfDay,
    isHoangDao: isHoangDao,
    hours: hours,
    lucDieuDay: lucDieuDay,
    hyThan: hyThanByCan[dayPair.can],
    taiThan: taiThanByCan[dayPair.can],
    mansion: mansionIndexFor(jd),
    rating: score >= 1
        ? DayRating.good
        : score <= -1
        ? DayRating.bad
        : DayRating.neutral,
  );
}
