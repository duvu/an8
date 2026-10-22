/// Step layout of a routine on a single time axis.
final class SessionTimeline {
  SessionTimeline(List<Duration> stepDurations)
    : assert(stepDurations.isNotEmpty),
      stepDurations = List.unmodifiable(stepDurations),
      _starts = _startsOf(stepDurations),
      total = stepDurations.fold(Duration.zero, (a, b) => a + b);

  final List<Duration> stepDurations;
  final List<Duration> _starts;
  final Duration total;

  int get stepCount => stepDurations.length;

  static List<Duration> _startsOf(List<Duration> durations) {
    final starts = <Duration>[];
    var at = Duration.zero;
    for (final d in durations) {
      starts.add(at);
      at += d;
    }
    return List.unmodifiable(starts);
  }

  Duration startOf(int step) => _starts[step];

  /// Index of the step playing at [position]; the end maps to the last step.
  int stepAt(Duration position) {
    for (var i = stepCount - 1; i > 0; i--) {
      if (position >= _starts[i]) return i;
    }
    return 0;
  }
}
