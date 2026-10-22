import 'package:an_nhien/features/session/domain/session_machine.dart';
import 'package:an_nhien/features/session/domain/session_timeline.dart';
import 'package:flutter_test/flutter_test.dart';

Duration s(int seconds) => Duration(seconds: seconds);

void main() {
  late SessionMachine machine;

  /// Steps: 10s, 20s, 30s (total 60s). Countdown 3s.
  SessionMachine started() {
    machine = SessionMachine(SessionTimeline([s(10), s(20), s(30)]))
      ..prepare()
      ..mediaReady(s(0));
    return machine;
  }

  group('SessionTimeline', () {
    final timeline = SessionTimeline([s(10), s(20), s(30)]);

    test('aggregates total and step starts', () {
      expect(timeline.total, s(60));
      expect(timeline.startOf(2), s(30));
    });

    test('maps positions to steps; end maps to last step', () {
      expect(timeline.stepAt(s(0)), 0);
      expect(timeline.stepAt(s(10)), 1);
      expect(timeline.stepAt(s(29)), 1);
      expect(timeline.stepAt(s(60)), 2);
    });
  });

  test('preparing does not run the timer', () {
    machine = SessionMachine(SessionTimeline([s(10)]))..prepare();
    final snap = machine.snapshot(s(100));
    expect(snap.status, SessionStatus.preparing);
    expect(snap.position, Duration.zero);
  });

  test('3 second countdown precedes playback and is not active time', () {
    started();
    expect(machine.snapshot(s(1)).status, SessionStatus.countdown);
    expect(machine.snapshot(s(1)).countdownRemaining, s(2));
    final snap = machine.snapshot(s(5));
    expect(snap.status, SessionStatus.playing);
    expect(snap.position, s(2));
    expect(snap.activeTime, s(2));
  });

  test('time derives from the monotonic clock, not from tick count', () {
    started();
    // A single late tick after a long gap still yields exact time.
    expect(machine.snapshot(s(13)).position, s(10));
    expect(machine.snapshot(s(13)).stepIndex, 1);
  });

  test('pause/resume excludes paused time and does not double count', () {
    started();
    machine.pause(s(8)); // 5s played
    expect(machine.snapshot(s(100)).position, s(5));
    machine.resume(s(100));
    machine.resume(s(101)); // ignored duplicate
    final snap = machine.snapshot(s(104));
    expect(snap.position, s(9));
    expect(snap.activeTime, s(9));
  });

  test('pause during countdown restarts countdown on resume', () {
    started();
    machine.pause(s(1));
    machine.resume(s(50));
    expect(machine.snapshot(s(51)).status, SessionStatus.countdown);
    expect(machine.snapshot(s(53)).status, SessionStatus.playing);
  });

  test('buffering freezes progress and active time', () {
    started();
    machine.bufferingStarted(s(5)); // 2s played
    expect(machine.snapshot(s(30)).position, s(2));
    expect(machine.snapshot(s(30)).status, SessionStatus.buffering);
    machine.bufferingEnded(s(30));
    expect(machine.snapshot(s(31)).activeTime, s(3));
  });

  test(
    'completes exactly at the end with active time equal to played time',
    () {
      started();
      final snap = machine.snapshot(s(500));
      expect(snap.status, SessionStatus.finished);
      expect(snap.outcome, SessionOutcome.completed);
      expect(snap.position, s(60));
      expect(snap.activeTime, s(60));
    },
  );

  test('next skips without adding skipped time to active time', () {
    started();
    machine.next(s(4)); // played 1s, jump to 10s
    final snap = machine.snapshot(s(6));
    expect(snap.position, s(12));
    expect(snap.stepIndex, 1);
    expect(snap.activeTime, s(3));
  });

  test('next is a no-op on the last step', () {
    started();
    machine.next(s(3));
    machine.next(s(3));
    expect(machine.canGoNext, isFalse);
    machine.next(s(3));
    expect(machine.snapshot(s(3)).position, s(30));
  });

  test('previous goes to the previous step when near the step start', () {
    started();
    machine.next(s(3)); // at 10s
    machine.pause(s(5)); // 12s, 2s into step 1
    machine.previous(s(5));
    expect(machine.snapshot(s(5)).position, s(0));
  });

  test('previous restarts current step when more than 3s in', () {
    started();
    machine.next(s(3)); // at 10s
    machine.pause(s(18)); // 15s
    machine.previous(s(18));
    expect(machine.snapshot(s(18)).position, s(10));
  });

  test('user exit is abandoned, never completed', () {
    started();
    machine.pause(s(20));
    machine.exit(s(21));
    final snap = machine.snapshot(s(22));
    expect(snap.outcome, SessionOutcome.abandoned);
    expect(snap.activeTime, s(17));
  });

  test('system interruption pauses and waits; exit records interrupted', () {
    started();
    machine.interrupt(s(10));
    expect(machine.snapshot(s(60)).status, SessionStatus.interrupted);
    expect(machine.snapshot(s(60)).position, s(7));
    machine.exit(s(60));
    expect(machine.snapshot(s(60)).outcome, SessionOutcome.interrupted);
  });

  test('media error stops time; retry resumes without countdown', () {
    started();
    machine.mediaFailed(s(8), 'boom');
    expect(machine.snapshot(s(20)).status, SessionStatus.error);
    expect(machine.snapshot(s(20)).position, s(5));
    machine.prepare();
    machine.mediaReady(s(20));
    expect(machine.snapshot(s(21)).status, SessionStatus.playing);
    expect(machine.snapshot(s(21)).position, s(6));
  });

  test('skipping a failed step moves to the next step, paused', () {
    started();
    machine.mediaFailed(s(5), 'boom');
    machine.skipFailedStep(s(6));
    final snap = machine.snapshot(s(9));
    expect(snap.status, SessionStatus.paused);
    expect(snap.position, s(10));
  });

  test('finished sessions ignore further events', () {
    started();
    machine.exit(s(5));
    machine.resume(s(6));
    machine.next(s(6));
    expect(machine.snapshot(s(10)).outcome, SessionOutcome.abandoned);
    expect(machine.snapshot(s(10)).position, s(2));
  });
}
