import 'dart:io';

import 'package:an_nhien/app/app.dart';
import 'package:an_nhien/app/router/app_router.dart';
import 'package:an_nhien/app/router/app_routes.dart';
import 'package:an_nhien/core/audio/music_player.dart';
import 'package:an_nhien/features/catalog/domain/catalog_models.dart';
import 'package:an_nhien/features/session/application/session_music.dart';
import 'package:an_nhien/features/session/domain/session_machine.dart';
import 'package:an_nhien/features/settings/domain/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';
import '../../support/test_app.dart';

Future<TestApp> _startSession(
  WidgetTester tester,
  String routineId, {
  required FakeMusicPlayer music,
  Preferences preferences = const Preferences(onboardingCompleted: true),
}) async {
  final app = await pumpTestApp(tester, music: music, preferences: preferences);
  final context = tester.element(find.byType(AnNhienApp));
  ProviderScope.containerOf(context)
      .read(appRouterProvider)
      .go(AppRoutes.session(routineId));
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  await settleIo(tester);
  return app;
}

void main() {
  group('musicFor', () {
    Routine routine(List<String> tags) => Routine(
      id: 'R',
      version: 1,
      locale: 'vi-VN',
      title: 'R',
      description: '',
      tags: tags,
      reviewStatus: ReviewStatus.approved,
      demoOnly: false,
      steps: const [],
    );

    test('picks the track from the routine tags (spec M1–M3)', () {
      expect(musicFor(routine(['morning', 'gentle'])), MusicTrack.morning);
      expect(musicFor(routine(['evening', 'seated'])), MusicTrack.evening);
      expect(
        musicFor(routine(['baduanjin', 'eastern-qigong'])),
        MusicTrack.qigong,
      );
      expect(musicFor(routine(['seated'])), MusicTrack.morning);
    });

    test('plays only while the session runs', () {
      expect(
        SessionStatus.values.where(musicShouldPlay),
        unorderedEquals([SessionStatus.countdown, SessionStatus.playing]),
      );
    });
  });

  test('every track is a bundled asset', () {
    for (final track in MusicTrack.values) {
      expect(File(track.asset).existsSync(), isTrue, reason: track.asset);
    }
  });

  testWidgets('music follows play, pause, resume and the end', (tester) async {
    final music = FakeMusicPlayer();
    final app = await _startSession(tester, 'R05', music: music);
    await app.elapse(const Duration(seconds: 4));
    expect(music.calls, ['play:evening']);

    await tester.tap(find.widgetWithText(FilledButton, 'Tạm dừng'));
    await tester.pump();
    expect(music.calls.last, 'pause');
    await tester.tap(
      find.descendant(of: find.byType(Dialog), matching: find.text('Tiếp tục')),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(music.calls.last, 'play:evening');

    await app.elapse(const Duration(minutes: 7));
    await tester.pumpAndSettle();
    await settleIo(tester);
    expect(find.text('Hoàn thành bài tập'), findsOneWidget);
    expect(music.calls.last, 'stop');
    await app.dispose();
  });

  testWidgets('Bát Đoạn Cẩm gets the qigong track', (tester) async {
    final music = FakeMusicPlayer();
    final app = await _startSession(tester, 'R101', music: music);
    await app.elapse(const Duration(seconds: 4));
    expect(music.calls, ['play:qigong']);
    await app.dispose();
  });

  testWidgets('no music when the setting is off', (tester) async {
    final music = FakeMusicPlayer();
    final app = await _startSession(
      tester,
      'R02',
      music: music,
      preferences: const Preferences(
        onboardingCompleted: true,
        backgroundMusic: false,
      ),
    );
    await app.elapse(const Duration(seconds: 10));
    expect(music.calls.where((c) => c.startsWith('play')), isEmpty);
    await app.dispose();
  });
}
