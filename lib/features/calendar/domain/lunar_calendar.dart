import 'dart:math' as math;

/// Vietnamese lunisolar calendar (UTC+7). Astronomical algorithm of Hồ Ngọc
/// Đức (new moon and sun longitude), valid for the Gregorian years 1900–2199.
const vietnamTimeZone = 7;

final class LunarDate {
  const LunarDate({
    required this.day,
    required this.month,
    required this.year,
    required this.isLeapMonth,
  });

  final int day;
  final int month;
  final int year;

  /// Tháng nhuận: repeats the number of the month before it.
  final bool isLeapMonth;

  @override
  bool operator ==(Object other) =>
      other is LunarDate &&
      other.day == day &&
      other.month == month &&
      other.year == year &&
      other.isLeapMonth == isLeapMonth;

  @override
  int get hashCode => Object.hash(day, month, year, isLeapMonth);

  @override
  String toString() => '$day/$month${isLeapMonth ? '+' : ''}/$year';
}

/// Julian day number of a Gregorian civil date.
int julianDayNumber(int year, int month, int day) {
  final a = (14 - month) ~/ 12;
  final y = year + 4800 - a;
  final m = month + 12 * a - 3;
  return day +
      (153 * m + 2) ~/ 5 +
      365 * y +
      y ~/ 4 -
      y ~/ 100 +
      y ~/ 400 -
      32045;
}

const _dr = math.pi / 180;
const _synodicMonth = 29.530588853;

int _newMoonDay(int k) {
  final t = k / 1236.85;
  final t2 = t * t;
  final t3 = t2 * t;
  var jd1 =
      2415020.75933 + _synodicMonth * k + 0.0001178 * t2 - 0.000000155 * t3;
  jd1 += 0.00033 * math.sin((166.56 + 132.87 * t - 0.009173 * t2) * _dr);
  final m = 359.2242 + 29.10535608 * k - 0.0000333 * t2 - 0.00000347 * t3;
  final mpr = 306.0253 + 385.81691806 * k + 0.0107306 * t2 + 0.00001236 * t3;
  final f = 21.2964 + 390.67050646 * k - 0.0016528 * t2 - 0.00000239 * t3;
  var c1 =
      (0.1734 - 0.000393 * t) * math.sin(m * _dr) +
      0.0021 * math.sin(2 * _dr * m);
  c1 -= 0.4068 * math.sin(mpr * _dr) - 0.0161 * math.sin(_dr * 2 * mpr);
  c1 -= 0.0004 * math.sin(_dr * 3 * mpr);
  c1 += 0.0104 * math.sin(_dr * 2 * f) - 0.0051 * math.sin(_dr * (m + mpr));
  c1 -=
      0.0074 * math.sin(_dr * (m - mpr)) - 0.0004 * math.sin(_dr * (2 * f + m));
  c1 -=
      0.0004 * math.sin(_dr * (2 * f - m)) +
      0.0006 * math.sin(_dr * (2 * f + mpr));
  c1 +=
      0.0010 * math.sin(_dr * (2 * f - mpr)) +
      0.0005 * math.sin(_dr * (2 * mpr + m));
  final deltaT = t < -11
      ? 0.001 +
            0.000839 * t +
            0.0002261 * t2 -
            0.00000845 * t3 -
            0.000000081 * t * t3
      : -0.000278 + 0.000265 * t + 0.000262 * t2;
  final jdNew = jd1 + c1 - deltaT;
  return (jdNew + 0.5 + vietnamTimeZone / 24).floor();
}

/// Apparent sun longitude in degrees [0, 360) at local midnight that starts
/// the civil day with Julian day number [jdn].
double sunLongitudeDegrees(int jdn) {
  final t = (jdn - 2451545.5 - vietnamTimeZone / 24) / 36525;
  final t2 = t * t;
  final m = 357.52910 + 35999.05030 * t - 0.0001559 * t2 - 0.00000048 * t * t2;
  final l0 = 280.46645 + 36000.76983 * t + 0.0003032 * t2;
  var dl = (1.914600 - 0.004817 * t - 0.000014 * t2) * math.sin(_dr * m);
  dl +=
      (0.019993 - 0.000101 * t) * math.sin(_dr * 2 * m) +
      0.000290 * math.sin(_dr * 3 * m);
  final l = (l0 + dl) * _dr;
  final wrapped = l - 2 * math.pi * (l / (2 * math.pi)).floor();
  return wrapped / _dr;
}

int _sunSector(int jdn) => (sunLongitudeDegrees(jdn) / 30).floor();

int _lunarMonth11(int year) {
  final off = julianDayNumber(year, 12, 31) - 2415021;
  final k = (off / _synodicMonth).floor();
  var nm = _newMoonDay(k);
  if (_sunSector(nm) >= 9) nm = _newMoonDay(k - 1);
  return nm;
}

int _leapMonthOffset(int a11) {
  final k = ((a11 - 2415021.076998695) / _synodicMonth + 0.5).floor();
  var i = 1;
  var arc = _sunSector(_newMoonDay(k + i));
  int last;
  do {
    last = arc;
    i++;
    arc = _sunSector(_newMoonDay(k + i));
  } while (arc != last && i < 14);
  return i - 1;
}

/// Lunar date of a Gregorian civil date (time of day ignored).
LunarDate solarToLunar(DateTime date) {
  final dayNumber = julianDayNumber(date.year, date.month, date.day);
  final k = ((dayNumber - 2415021.076998695) / _synodicMonth).floor();
  var monthStart = _newMoonDay(k + 1);
  if (monthStart > dayNumber) monthStart = _newMoonDay(k);
  var a11 = _lunarMonth11(date.year);
  var b11 = a11;
  int lunarYear;
  if (a11 >= monthStart) {
    lunarYear = date.year;
    a11 = _lunarMonth11(date.year - 1);
  } else {
    lunarYear = date.year + 1;
    b11 = _lunarMonth11(date.year + 1);
  }
  final lunarDay = dayNumber - monthStart + 1;
  final diff = ((monthStart - a11) / 29).floor();
  var isLeap = false;
  var lunarMonth = diff + 11;
  if (b11 - a11 > 365) {
    final leapOffset = _leapMonthOffset(a11);
    if (diff >= leapOffset) {
      lunarMonth = diff + 10;
      if (diff == leapOffset) isLeap = true;
    }
  }
  if (lunarMonth > 12) lunarMonth -= 12;
  if (lunarMonth >= 11 && diff < 4) lunarYear -= 1;
  return LunarDate(
    day: lunarDay,
    month: lunarMonth,
    year: lunarYear,
    isLeapMonth: isLeap,
  );
}
