import 'package:flutter/material.dart';

/// One canonical An identity; never draw an independent lotus in another widget.
abstract final class AnBrand {
  static const String name = 'An';
  static const Color primary = Color(0xFF073F3B);
  static const Color secondary = Color(0xFF0A5249);
  static const Color mint = Color(0xFF7FD1BC);
  static const Color cream = Color(0xFFFAF9F3);
  static const String _assets = 'packages/an_brand/assets/icons/';
  static const String lotus = '${_assets}lotus_mark.png';
  static const String lockupLight = '${_assets}lockup_on_light.png';
  static const String lockupDark = '${_assets}lockup_on_dark.png';
  static const String videoOverlay = '${_assets}video_overlay.png';
}

class AnLotus extends StatelessWidget {
  const AnLotus({super.key, this.size = 36, this.semanticLabel = 'Biểu tượng hoa sen An'});
  final double size;
  final String semanticLabel;
  @override
  Widget build(BuildContext context) => Image.asset(
    AnBrand.lotus,
    width: size, height: size,
    fit: BoxFit.contain,
    semanticLabel: semanticLabel,
  );
}

class AnLockup extends StatelessWidget {
  const AnLockup({super.key, this.height = 54, this.onDark = false});
  final double height;
  final bool onDark;
  @override
  Widget build(BuildContext context) => Image.asset(
    onDark ? AnBrand.lockupDark : AnBrand.lockupLight,
    height: height, fit: BoxFit.contain,
    alignment: Alignment.centerLeft,
    semanticLabel: 'An',
  );
}

/// In the player Stack, place with Positioned(top: 24, right: 24, child: ...).
/// Do NOT bake it into source exercise footage or cover a joint/limb.
class AnVideoBrandOverlay extends StatelessWidget {
  const AnVideoBrandOverlay({super.key, this.width = 120});
  final double width;
  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Image.asset(AnBrand.videoOverlay,
      width: width, fit: BoxFit.contain, semanticLabel: 'An'),
  );
}
