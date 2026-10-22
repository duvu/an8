import 'package:flutter/services.dart';

/// Answers which media files are on the device (bundled today; downloaded packs later).
abstract interface class MediaAvailability {
  Future<Set<String>> availablePaths();
}

final class BundledMediaAvailability implements MediaAvailability {
  const BundledMediaAvailability(this._bundle);

  final AssetBundle _bundle;

  @override
  Future<Set<String>> availablePaths() async =>
      (await AssetManifest.loadFromAssetBundle(_bundle)).listAssets().toSet();
}
