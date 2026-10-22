import 'package:flutter/material.dart';

import '../../../app/theme/semantic_tokens.dart';

/// Label over player media: demo notice, or the large 3-2-1 countdown.
class PlayerChip extends StatelessWidget {
  const PlayerChip({super.key, required this.text, this.large = false});

  final String text;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = large
        ? theme.textTheme.headlineSmall
        : theme.textTheme.labelMedium;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? AppSpacing.xl : AppSpacing.sm,
        vertical: large ? AppSpacing.md : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.appColors.accent,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.sm)),
      ),
      child: Text(
        text,
        style: style?.copyWith(color: theme.appColors.onAccent),
      ),
    );
  }
}
