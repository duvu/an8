import '../../../core/audio/cue_player.dart';
import '../domain/session_machine.dart';
import 'session_controller.dart';

/// Advance warning before a step ends: on screen (distance view) and as a cue.
const stepEndingWarning = Duration(seconds: 10);

/// Which sound cues to play for the change from [before] to [after].
/// Pure: driven only by two consecutive session states, so each cue fires once.
List<SoundCue> sessionCues(SessionViewState? before, SessionViewState after) {
  final a = after.snapshot;
  final b = before?.snapshot;
  if (a.outcome == SessionOutcome.completed) {
    return b?.outcome == SessionOutcome.completed
        ? const []
        : const [SoundCue.complete];
  }
  final cues = <SoundCue>[];
  if (a.status == SessionStatus.countdown) {
    final second = _ceilSeconds(a.countdownRemaining);
    final previous = b?.status == SessionStatus.countdown
        ? _ceilSeconds(b!.countdownRemaining)
        : null;
    if (second > 0 && second != previous) cues.add(SoundCue.countdown);
  }
  if (a.status == SessionStatus.playing && b != null) {
    final firstStepBegins = b.status == SessionStatus.countdown;
    final stepChanged =
        b.status == SessionStatus.playing && a.stepIndex != b.stepIndex;
    if (firstStepBegins || stepChanged) cues.add(SoundCue.stepStart);
    if (b.status == SessionStatus.playing &&
        a.stepIndex == b.stepIndex &&
        after.hasNext &&
        before!.stepRemaining > stepEndingWarning &&
        after.stepRemaining <= stepEndingWarning) {
      cues.add(SoundCue.stepSoon);
    }
  }
  return cues;
}

int _ceilSeconds(Duration d) => (d.inMilliseconds + 999) ~/ 1000;
