/// Time source. Elapsed time always comes from [monotonic], never from tick
/// counts or wall-clock differences; [now] is only for timestamps.
abstract interface class AppClock {
  Duration monotonic();
  DateTime now();
}

final class SystemClock implements AppClock {
  SystemClock() : _stopwatch = Stopwatch()..start();

  final Stopwatch _stopwatch;

  @override
  Duration monotonic() => _stopwatch.elapsed;

  @override
  DateTime now() => DateTime.now();
}
