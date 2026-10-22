import 'package:audio_session/audio_session.dart';

Future<void>? _configured;

/// One app-wide audio session for cues and background music: mix with (and
/// briefly duck) other apps instead of taking focus, so we never pause the
/// user's own audio and never trigger our own interruption handling.
Future<void> configureAppAudioSession() => _configured ??= () async {
  final session = await AudioSession.instance;
  await session.configure(
    const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.mixWithOthers,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.sonification,
        usage: AndroidAudioUsage.assistanceSonification,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransientMayDuck,
    ),
  );
}();
