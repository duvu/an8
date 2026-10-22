import 'almanac_tables.dart';
import 'day_almanac.dart';

/// Activities people ask the almanac about.
enum Activity { wedding, opening, building, departure, burial, lawsuit }

enum Verdict { favorable, neutral, unfavorable }

/// What an item of evidence comes from.
enum EvidenceSource { hoangDao, truc, mansion, lucDieu }

/// One reason for or against doing an activity today.
final class Evidence {
  const Evidence(this.source, {required this.favorable, required this.name});

  final EvidenceSource source;

  /// True when it speaks for the activity, false when against.
  final bool favorable;

  /// Hoàng đạo/hắc đạo god, trực, sao or lục diệu name.
  final String name;
}

final class ActivityAdvice {
  const ActivityAdvice(this.activity, this.verdict, this.evidence);

  final Activity activity;
  final Verdict verdict;
  final List<Evidence> evidence;
}

// Words of the verified texts (trực notes, sao "nên làm" / "kiêng cữ") that
// name each activity. Advice is derived from those texts, not from a second
// table: see DECISIONS D28.
const _keywords = <Activity, List<String>>{
  Activity.wedding: ['cưới gả', 'cưới hỏi', 'hôn nhân', 'giá thú'],
  Activity.opening: ['khai trương'],
  Activity.building: [
    'khởi công',
    'khởi tạo',
    'tạo tác',
    'xây cất',
    'xây dựng',
    'dựng nhà',
    'dựng cột',
    'cất lầu',
    'động thổ',
  ],
  Activity.departure: ['xuất hành'],
  Activity.burial: ['chôn cất', 'mồ mả', 'phần mộ', 'mộ phần', 'thọ đường'],
  Activity.lawsuit: ['kiện', 'tranh tụng'],
};

bool _mentions(String text, Activity activity) {
  final lower = text.toLowerCase();
  return _keywords[activity]!.any(lower.contains);
}

/// Activities a bad trực spoils without naming them.
bool _isMajor(Activity activity) => activity != Activity.lawsuit;

/// Sign of the trực for [activity]: words before "tránh" speak for it, words
/// after against; a bad trực is against every major activity.
int _trucSign(DayAlmanac a, Activity activity) {
  final parts = a.trucDetail.note.split('tránh');
  if (parts.length > 1 && _mentions(parts[1], activity)) return -1;
  if (_mentions(parts[0], activity)) return 1;
  if (a.trucDetail.level == TrucLevel.bad && _isMajor(activity)) return -1;
  return 0;
}

int _mansionSign(DayAlmanac a, Activity activity) {
  final m = a.mansionDetail;
  if (_mentions(m.avoid, activity)) return -1;
  if (_mentions(m.favorable, activity)) return 1;
  return 0;
}

/// Advice for each of [Activity.values] on the day [a]. Hoàng đạo or hắc đạo
/// (all but lawsuits), trực, sao nhị thập bát tú and, for departures, the
/// Khổng Minh lục diệu each cast one vote for or against; the net vote decides
/// and a tie is neutral. Lawsuits can only be discouraged.
List<ActivityAdvice> adviceFor(DayAlmanac a) => [
  for (final activity in Activity.values) _adviceOne(a, activity),
];

ActivityAdvice _adviceOne(DayAlmanac a, Activity activity) {
  final evidence = <Evidence>[];
  void add(EvidenceSource source, int sign, String name) {
    if (sign != 0) {
      evidence.add(Evidence(source, favorable: sign > 0, name: name));
    }
  }

  if (_isMajor(activity)) {
    add(EvidenceSource.hoangDao, a.isHoangDao ? 1 : -1, a.godName);
  }
  add(EvidenceSource.truc, _trucSign(a, activity), a.trucName);
  add(EvidenceSource.mansion, _mansionSign(a, activity), a.mansionDetail.name);
  if (activity == Activity.departure) {
    add(
      EvidenceSource.lucDieu,
      a.lucDieuDayInfo.level == LucDieuLevel.good ? 1 : -1,
      a.lucDieuDayInfo.name,
    );
  }

  final score = evidence.fold<int>(0, (s, e) => s + (e.favorable ? 1 : -1));
  var verdict = score > 0
      ? Verdict.favorable
      : score < 0
      ? Verdict.unfavorable
      : Verdict.neutral;
  if (activity == Activity.lawsuit && verdict == Verdict.favorable) {
    verdict = Verdict.neutral;
  }
  return ActivityAdvice(activity, verdict, evidence);
}
