import 'package:flutter/material.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../domain/catalog_models.dart';
import 'catalog_labels.dart';
import 'demo_label.dart';
import 'routine_image.dart';

class RoutineCard extends StatelessWidget {
  const RoutineCard({
    super.key,
    required this.catalog,
    required this.routine,
    required this.onOpen,
    this.onStart,
    this.trailing,
  });

  final ContentCatalog catalog;
  final Routine routine;
  final VoidCallback onOpen;

  /// When set, the card shows the primary start action.
  final VoidCallback? onStart;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (onStart != null) ...[
                RoutineImage(catalog: catalog, routine: routine),
                const SizedBox(height: AppSpacing.md),
              ],
              // Wrap, not Row: the badge moves below the title at large text sizes.
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(routine.title, style: theme.textTheme.titleLarge),
                  if (catalog.isPreviewOnly(routine)) const DemoBadge(),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.routineMeta(catalog, routine),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.appColors.textSecondary,
                ),
              ),
              if (trailing case final trailing?) ...[
                const SizedBox(height: AppSpacing.sm),
                trailing,
              ],
              if (onStart case final onStart?) ...[
                const SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  onPressed: onStart,
                  icon: const Icon(Icons.play_arrow),
                  label: Text(l10n.startAction),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
