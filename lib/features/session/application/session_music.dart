import '../../../core/audio/music_player.dart';
import '../../catalog/domain/catalog_models.dart';
import '../domain/session_machine.dart';

/// Track for a routine, from its catalog tags (music spec M1–M3).
MusicTrack musicFor(Routine routine) {
  final tags = routine.tags;
  if (tags.contains('eastern-qigong')) return MusicTrack.qigong;
  if (tags.contains('evening')) return MusicTrack.evening;
  return MusicTrack.morning;
}

/// Music runs only while the session itself runs; pauses, interruptions,
/// loading and errors silence it.
bool musicShouldPlay(SessionStatus status) =>
    status == SessionStatus.countdown || status == SessionStatus.playing;
