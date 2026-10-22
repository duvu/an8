import 'package:flutter/material.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/semantic_tokens.dart';

/// Marks unapproved content (P03). Text, not color alone, carries the meaning.
class DemoBadge extends StatelessWidget {
  const DemoBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.appColors.warning,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.sm)),
      ),
      child: Text(
        AppLocalizations.of(context).demoBadge,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.appColors.onAccent,
        ),
      ),
    );
  }
}

class DemoBanner extends StatelessWidget {
  const DemoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.appColors.surfaceElevated,
        border: Border.all(color: theme.appColors.warning),
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.sm)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: theme.appColors.warning),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(AppLocalizations.of(context).demoBanner)),
        ],
      ),
    );
  }
}
