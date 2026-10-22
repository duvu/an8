/// `mm:ss`, rounding up so a countdown never shows 00:00 while time remains.
String formatClock(Duration d) {
  final total = d.isNegative ? 0 : (d.inMilliseconds + 999) ~/ 1000;
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(total ~/ 60)}:${two(total % 60)}';
}
