import 'package:an_nhien/core/audio/cue_player.dart';
import 'package:an_nhien/features/settings/domain/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';
import '../../support/test_app.dart';

void main() {
  testWidgets('player plays countdown, step, warning and completion cues', (
    tester,
  ) async {
    final cues = FakeCuePlayer();
    final app = await pumpTestApp(tester, cues: cues);
    await openPlayerFromHome(tester);
    expect(cues.preloaded, isTrue);

    for (var i = 0; i < 3; i++) {
      await app.elapse(const Duration(seconds: 1));
    }
    expect(cues.played, [
      SoundCue.countdown,
      SoundCue.countdown,
      SoundCue.countdown,
      SoundCue.stepStart,
    ]);

    cues.played.clear();
    await app.elapse(const Duration(seconds: 111)); // 9 s left in step 1
    expect(cues.played, [SoundCue.stepSoon]);

    cues.played.clear();
    await app.elapse(const Duration(seconds: 10)); // step 2
    expect(cues.played, [SoundCue.stepStart]);

    cues.played.clear();
    await app.elapse(const Duration(minutes: 5));
    await tester.pumpAndSettle();
    await settleIo(tester);
    expect(cues.played.last, SoundCue.complete);
    expect(find.text('Hoàn thành bài tập'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('no cues when sound cues are turned off', (tester) async {
    final cues = FakeCuePlayer();
    final app = await pumpTestApp(
      tester,
      cues: cues,
      preferences: const Preferences(
        onboardingCompleted: true,
        soundCues: false,
      ),
    );
    await openPlayerFromHome(tester);
    await app.elapse(const Duration(seconds: 5));
    expect(cues.preloaded, isFalse);
    expect(cues.played, isEmpty);
    expect(find.byType(Scaffold), findsWidgets);
    await app.dispose();
  });
}
