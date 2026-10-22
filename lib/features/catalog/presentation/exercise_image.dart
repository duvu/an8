import 'package:flutter/material.dart';

import '../../../app/theme/semantic_tokens.dart';

/// Bundled exercise image, letterboxed so the body is never cropped.
class ExerciseImage extends StatelessWidget {
  const ExerciseImage({
    super.key,
    required this.path,
    required this.semanticLabel,
    this.aspectRatio = 16 / 9,
  });

  final String? path;
  final String semanticLabel;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final fallback = ColoredBox(
      color: colors.surfaceElevated,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: colors.textSecondary,
      ),
    );
    final path = this.path;
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
        child: ColoredBox(
          color: colors.surfaceElevated,
          child: path == null
              ? fallback
              : Image.asset(
                  path,
                  fit: BoxFit.contain,
                  semanticLabel: semanticLabel,
                  gaplessPlayback: true,
                  errorBuilder: (_, _, _) => fallback,
                ),
        ),
      ),
    );
  }
}
