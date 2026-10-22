import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Media adapter for the player: makes a step's media ready before the clock runs.
/// Storyboard frames today; a video/voice adapter can replace it once approved media exists.
abstract interface class MediaPreloader {
  /// True when every path loaded.
  Future<bool> preload(BuildContext context, Set<String> paths);
}

final class ImageMediaPreloader implements MediaPreloader {
  const ImageMediaPreloader();

  @override
  Future<bool> preload(BuildContext context, Set<String> paths) async {
    var ok = true;
    for (final path in paths) {
      if (!context.mounted) return false;
      await precacheImage(
        AssetImage(path),
        context,
        onError: (_, _) => ok = false,
      );
    }
    return ok;
  }
}

final mediaPreloaderProvider = Provider<MediaPreloader>(
  (ref) => const ImageMediaPreloader(),
);
