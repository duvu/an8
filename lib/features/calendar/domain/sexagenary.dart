/// Thiên can (10 heavenly stems) and địa chi (12 earthly branches).
const canNames = [
  'Giáp', 'Ất', 'Bính', 'Đinh', 'Mậu', 'Kỷ', 'Canh', 'Tân', 'Nhâm', 'Quý', //
];

const chiNames = [
  'Tý', 'Sửu', 'Dần', 'Mão', 'Thìn', 'Tỵ', 'Ngọ', 'Mùi', 'Thân', 'Dậu', //
  'Tuất', 'Hợi',
];

/// A can-chi pair such as "Giáp Tý"; [can] 0–9 (Giáp = 0), [chi] 0–11 (Tý = 0).
final class CanChi {
  const CanChi(this.can, this.chi);

  final int can;
  final int chi;

  String get name => '${canNames[can]} ${chiNames[chi]}';

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      other is CanChi && other.can == can && other.chi == chi;

  @override
  int get hashCode => Object.hash(can, chi);
}

int _mod(int a, int n) => ((a % n) + n) % n;

/// Day pair from the Julian day number.
CanChi dayCanChi(int julianDay) =>
    CanChi(_mod(julianDay + 9, 10), _mod(julianDay + 1, 12));

/// Lunar year pair (e.g. 2025 = Ất Tỵ).
CanChi yearCanChi(int lunarYear) =>
    CanChi(_mod(lunarYear + 6, 10), _mod(lunarYear + 8, 12));

/// Pair of lunar month [month] (1–12) in a lunar year whose stem is
/// [yearCan]: month 1 is Dần; its stem follows the "ngũ hổ độn" rule.
CanChi monthCanChi(int yearCan, int month) =>
    CanChi(_mod((yearCan % 5) * 2 + 2 + (month - 1), 10), _mod(month + 1, 12));
