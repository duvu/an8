import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import 'audio_session_config.dart';

/// Bundled background music (D17); built by `scripts/build_music.py`.
enum MusicTrack {
  morning('assets/audio/music/music_morning.m4a'),
  evening('assets/audio/music/music_evening.m4a'),
  qigong('assets/audio/music/music_qigong.m4a');

  const MusicTrack(this.asset);

  final String asset;
}

/// Looping background music. Every call is fire-and-forget: music failing
/// must never disturb the session.
abstract interface class MusicPlayer {
  /// Starts [track] (or resumes it where it was paused).
  void play(MusicTrack track);
  void pause();
  void stop();
  Future<void> dispose();
}

final class JustAudioMusicPlayer implements MusicPlayer {
  final _player = AudioPlayer();
  MusicTrack? _loaded;

  /// Calls run in order, so a quick play → pause cannot end up playing.
  Future<void> _queue = Future.value();

  void _run(String what, Future<void> Function() action) {
    _queue = _queue
        .then((_) => action())
        .catchError((Object e) => debugPrint('Music $what failed: $e'));
  }

  @override
  void play(MusicTrack track) => _run('play', () async {
    if (_loaded != track) {
      await configureAppAudioSession();
      await _player.setAsset(track.asset);
      await _player.setLoopMode(LoopMode.one);
      _loaded = track;
    }
    // Completes only when playback stops, so it is not awaited.
    _player.play().ignore();
  });

  @override
  void pause() => _run('pause', _player.pause);

  @override
  void stop() => _run('stop', () async {
    await _player.stop();
    await _player.seek(Duration.zero);
  });

  @override
  Future<void> dispose() => _player.dispose();
}

final musicPlayerProvider = Provider<MusicPlayer>((ref) {
  final player = JustAudioMusicPlayer();
  ref.onDispose(player.dispose);
  return player;
});
