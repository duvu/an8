import 'package:an_nhien/core/audio/cue_player.dart';
import 'package:an_nhien/features/catalog/data/catalog_manifest_parser.dart';
import 'package:an_nhien/features/session/application/session_controller.dart';
import 'package:an_nhien/features/session/application/session_cues.dart';
import 'package:an_nhien/features/session/domain/session_machine.dart';
import 'package:an_nhien/features/session/domain/session_plan.dart';
import 'package:flutter_test/flutter_test.dart';

import '../catalog/catalog_test_data.dart';

void main() {
  final catalog = const CatalogManifestParser().parse(readManifest());
  final plan = SessionPlan.from(catalog, catalog.routine('R01')!); // 3 × 120 s

  SessionViewState view(
    SessionStatus status, {
    Duration position = Duration.zero,
    Duration countdown = Duration.zero,
    SessionOutcome? outcome,
  }) => SessionViewState(
    plan: plan,
    snapshot: SessionSnapshot(
      status: status,
      position: position,
      activeTime: position,
      stepIndex: plan.timeline.stepAt(position),
      countdownRemaining: countdown,
      outcome: outcome,
    ),
  );

  Duration s(num seconds) => Duration(milliseconds: (seconds * 1000).round());

  test('countdown ticks once per displayed second', () {
    final start = view(SessionStatus.countdown, countdown: s(3));
    expect(sessionCues(view(SessionStatus.preparing), start), [
      SoundCue.countdown,
    ]);
    expect(
      sessionCues(start, view(SessionStatus.countdown, countdown: s(2.8))),
      isEmpty,
    );
    expect(
      sessionCues(
        view(SessionStatus.countdown, countdown: s(2.1)),
        view(SessionStatus.countdown, countdown: s(1.9)),
      ),
      [SoundCue.countdown],
    );
  });

  test('first step starts after the countdown', () {
    expect(
      sessionCues(
        view(SessionStatus.countdown, countdown: s(0.1)),
        view(SessionStatus.playing, position: s(0.1)),
      ),
      [SoundCue.stepStart],
    );
  });

  test('warns once when 10 s remain and a next step exists', () {
    final before = view(SessionStatus.playing, position: s(109.9));
    final after = view(SessionStatus.playing, position: s(110.1));
    expect(sessionCues(before, after), [SoundCue.stepSoon]);
    expect(
      sessionCues(after, view(SessionStatus.playing, position: s(110.3))),
      isEmpty,
    );
  });

  test('no step warning before the last step ends; completion instead', () {
    expect(
      sessionCues(
        view(SessionStatus.playing, position: s(349.9)),
        view(SessionStatus.playing, position: s(350.1)),
      ),
      isEmpty,
    );
    final done = view(
      SessionStatus.finished,
      position: s(360),
      outcome: SessionOutcome.completed,
    );
    expect(sessionCues(view(SessionStatus.playing, position: s(359.9)), done), [
      SoundCue.complete,
    ]);
    expect(sessionCues(done, done), isEmpty);
  });

  test('step change plays the new-step cue', () {
    expect(
      sessionCues(
        view(SessionStatus.playing, position: s(119.9)),
        view(SessionStatus.playing, position: s(120.1)),
      ),
      [SoundCue.stepStart],
    );
  });

  test('no cues while paused, on resume, or when ending early', () {
    final paused = view(SessionStatus.paused, position: s(115));
    expect(
      sessionCues(view(SessionStatus.playing, position: s(115)), paused),
      isEmpty,
    );
    expect(
      sessionCues(paused, view(SessionStatus.playing, position: s(115))),
      isEmpty,
    );
    expect(
      sessionCues(
        paused,
        view(
          SessionStatus.finished,
          position: s(115),
          outcome: SessionOutcome.abandoned,
        ),
      ),
      isEmpty,
    );
  });
}
