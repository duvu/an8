import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import 'audio_session_config.dart';

/// Short UI sounds for a phone placed away from the user (Media Kit v0.4 cues).
enum SoundCue {
  countdown('assets/audio/cues/cue_countdown.m4a'),
  stepStart('assets/audio/cues/cue_step_start.m4a'),
  stepSoon('assets/audio/cues/cue_step_soon.m4a'),
  complete('assets/audio/cues/cue_complete.m4a');

  const SoundCue(this.asset);

  final String asset;
}

abstract interface class CuePlayer {
  /// Loads every cue up front so the first one plays without delay.
  Future<void> preload();

  /// Fire-and-forget; a failing cue must never disturb the session.
  void play(SoundCue cue);
  Future<void> dispose();
}

/// One preloaded player per cue, on the shared app audio session.
final class JustAudioCuePlayer implements CuePlayer {
  final _players = <SoundCue, Future<AudioPlayer>>{};

  Future<AudioPlayer> _player(SoundCue cue) => _players[cue] ??= () async {
    await configureAppAudioSession();
    final player = AudioPlayer();
    await player.setAsset(cue.asset);
    return player;
  }();

  @override
  Future<void> preload() async {
    try {
      await Future.wait(SoundCue.values.map(_player));
    } on Object catch (e) {
      debugPrint('Sound cues unavailable: $e');
    }
  }

  @override
  void play(SoundCue cue) {
    () async {
      final player = await _player(cue);
      await player.seek(Duration.zero);
      await player.play();
    }().catchError((Object e) => debugPrint('Sound cue $cue failed: $e'));
  }

  @override
  Future<void> dispose() async {
    for (final player in _players.values) {
      await (await player).dispose();
    }
    _players.clear();
  }
}

final cuePlayerProvider = Provider<CuePlayer>((ref) {
  final player = JustAudioCuePlayer();
  ref.onDispose(player.dispose);
  return player;
});
