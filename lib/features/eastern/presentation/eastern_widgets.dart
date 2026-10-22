import 'package:flutter/material.dart';

import '../../../app/theme/semantic_tokens.dart';

/// Practice status, in words and icon (never color alone).
class EasternStatusLabel extends StatelessWidget {
  const EasternStatusLabel({
    super.key,
    required this.text,
    this.playable = false,
  });

  final String text;
  final bool playable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = playable ? theme.appColors.success : theme.appColors.warning;
    return Row(
      children: [
        Icon(
          playable ? Icons.check_circle_outline : Icons.hourglass_empty,
          color: color,
        ),
        const SizedBox(width: AppSpacing.xs),
        Flexible(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

class EasternCover extends StatelessWidget {
  const EasternCover({
    super.key,
    required this.assetKey,
    required this.semanticLabel,
    required this.width,
  });

  /// Covers are 3:4 portraits.
  static const aspectRatio = 3 / 4;

  final String assetKey;
  final String semanticLabel;
  final double width;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(AppRadius.sm)),
      child: SizedBox(
        width: width,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Image.asset(
            assetKey,
            fit: BoxFit.cover,
            semanticLabel: semanticLabel,
            errorBuilder: (_, _, _) => ColoredBox(
              color: colors.surfaceElevated,
              child: Icon(Icons.spa_outlined, color: colors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}

/// Warning box: an illustration is not technique instruction.
class EasternNotice extends StatelessWidget {
  const EasternNotice({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        border: Border.all(color: colors.warning),
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.sm)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: colors.warning),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
