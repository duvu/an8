import 'session_timeline.dart';

/// Player states (PRD §8.3, wireframe §5). [interrupted] is a system pause that
/// waits for the user; [finished] carries a [SessionOutcome].
enum SessionStatus {
  idle,
  preparing,
  countdown,
  playing,
  paused,
  interrupted,
  buffering,
  error,
  finished,
}

enum SessionOutcome { completed, abandoned, interrupted }

final class SessionSnapshot {
  const SessionSnapshot({
    required this.status,
    required this.position,
    required this.activeTime,
    required this.stepIndex,
    required this.countdownRemaining,
    this.outcome,
    this.errorMessage,
  });

  final SessionStatus status;

  /// Position on the routine timeline (skips move it; only playback advances it).
  final Duration position;

  /// Time actually spent playing; excludes countdown, pauses, buffering and skips.
  final Duration activeTime;
  final int stepIndex;
  final Duration countdownRemaining;
  final SessionOutcome? outcome;
  final String? errorMessage;
}

/// Explicit session state machine driven by a monotonic time `now`.
/// Invalid transitions are ignored, so UI double-taps cannot corrupt state.
final class SessionMachine {
  SessionMachine(this.timeline, {this.countdown = const Duration(seconds: 3)});

  final SessionTimeline timeline;
  final Duration countdown;

  SessionStatus _status = SessionStatus.idle;
  SessionOutcome? _outcome;
  String? _error;
  Duration _position = Duration.zero;
  Duration _active = Duration.zero;
  bool _hasPlayed = false;

  /// Monotonic time when the current countdown/playing segment started.
  Duration _anchor = Duration.zero;

  SessionStatus get status => _status;

  void prepare() {
    if (_status case SessionStatus.idle || SessionStatus.error) {
      _status = SessionStatus.preparing;
      _error = null;
    }
  }

  void mediaReady(Duration now) {
    tick(now);
    if (_status != SessionStatus.preparing) return;
    _hasPlayed ? _startPlaying(now) : _startCountdown(now);
  }

  void mediaFailed(Duration now, String message) {
    if (_status case SessionStatus.finished || SessionStatus.idle) return;
    _commit(now);
    _status = SessionStatus.error;
    _error = message;
  }

  void tick(Duration now) {
    switch (_status) {
      case SessionStatus.countdown when now - _anchor >= countdown:
        _hasPlayed = true;
        _startPlaying(_anchor + countdown);
        tick(now);
      case SessionStatus.playing:
        if (_position + (now - _anchor) >= timeline.total) {
          _active += timeline.total - _position;
          _position = timeline.total;
          _finish(SessionOutcome.completed);
        }
      default:
    }
  }

  void pause(Duration now) => _hold(now, SessionStatus.paused);

  /// Phone call, audio-focus loss, backgrounding or screen lock.
  void interrupt(Duration now) => _hold(now, SessionStatus.interrupted);

  void resume(Duration now) {
    tick(now);
    if (_status case SessionStatus.paused || SessionStatus.interrupted) {
      _hasPlayed ? _startPlaying(now) : _startCountdown(now);
    }
  }

  void bufferingStarted(Duration now) {
    tick(now);
    if (_status != SessionStatus.playing) return;
    _commit(now);
    _status = SessionStatus.buffering;
  }

  void bufferingEnded(Duration now) {
    tick(now);
    if (_status == SessionStatus.buffering) _startPlaying(now);
  }

  /// Based on the last committed position; callers pass through [next] for live checks.
  bool get canGoNext => timeline.stepAt(_position) < timeline.stepCount - 1;

  void next(Duration now) {
    _commit(now);
    if (!_seekable || !canGoNext) return;
    _seek(now, timeline.startOf(timeline.stepAt(_position) + 1));
  }

  /// Restarts the current step, or goes to the previous one when near its start.
  void previous(
    Duration now, {
    Duration restartThreshold = const Duration(seconds: 3),
  }) {
    _commit(now);
    if (!_seekable) return;
    final step = timeline.stepAt(_position);
    final start = timeline.startOf(step);
    final target = _position - start > restartThreshold || step == 0
        ? start
        : timeline.startOf(step - 1);
    _seek(now, target);
  }

  /// Skipping a failed step resumes from the next one, paused.
  void skipFailedStep(Duration now) {
    tick(now);
    if (_status != SessionStatus.error || !canGoNext) return;
    _position = timeline.startOf(timeline.stepAt(_position) + 1);
    _status = SessionStatus.paused;
    _error = null;
  }

  /// Ends early. Outcome is [SessionOutcome.interrupted] when the system had paused it.
  void exit(Duration now) {
    if (_status case SessionStatus.finished || SessionStatus.idle) return;
    final interrupted = _status == SessionStatus.interrupted;
    _commit(now);
    _finish(
      interrupted ? SessionOutcome.interrupted : SessionOutcome.abandoned,
    );
  }

  SessionSnapshot snapshot(Duration now) {
    tick(now);
    final live = _status == SessionStatus.playing
        ? now - _anchor
        : Duration.zero;
    final position = _position + live;
    return SessionSnapshot(
      status: _status,
      position: position,
      activeTime: _active + live,
      stepIndex: timeline.stepAt(position),
      countdownRemaining: _status == SessionStatus.countdown
          ? countdown - (now - _anchor)
          : Duration.zero,
      outcome: _outcome,
      errorMessage: _error,
    );
  }

  bool get _seekable => switch (_status) {
    SessionStatus.playing ||
    SessionStatus.paused ||
    SessionStatus.interrupted ||
    SessionStatus.buffering => true,
    _ => false,
  };

  void _seek(Duration now, Duration target) {
    _commit(now);
    _position = target;
    if (_status == SessionStatus.playing) _anchor = now;
  }

  void _hold(Duration now, SessionStatus to) {
    tick(now);
    if (_status
        case SessionStatus.playing ||
            SessionStatus.countdown ||
            SessionStatus.buffering ||
            SessionStatus.paused) {
      _commit(now);
      _status = to;
    }
  }

  /// Folds the live playing segment into position/active time.
  void _commit(Duration now) {
    tick(now);
    if (_status != SessionStatus.playing) return;
    final played = now - _anchor;
    _position += played;
    _active += played;
    _anchor = now;
  }

  void _startCountdown(Duration now) {
    _status = SessionStatus.countdown;
    _anchor = now;
  }

  void _startPlaying(Duration now) {
    _status = SessionStatus.playing;
    _anchor = now;
  }

  void _finish(SessionOutcome outcome) {
    _status = SessionStatus.finished;
    _outcome = outcome;
  }
}
