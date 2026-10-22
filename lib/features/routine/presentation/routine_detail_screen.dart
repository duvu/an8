import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/component_tokens.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../../../core/ui/async_value_view.dart';
import '../../catalog/application/catalog_providers.dart';
import '../../catalog/presentation/catalog_labels.dart';
import '../../catalog/presentation/demo_label.dart';
import '../../catalog/presentation/exercise_image.dart';
import '../../catalog/presentation/routine_image.dart';
import '../../learn/application/learn_providers.dart';

class RoutineDetailScreen extends ConsumerWidget {
  const RoutineDetailScreen({super.key, required this.routineId});

  final String routineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final available = ref.watch(routineAvailableProvider(routineId));
    final learn = ref.watch(culturalContentProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.detailTitle)),
      body: AsyncValueView(
        value: ref.watch(catalogProvider),
        onRetry: () => ref.invalidate(catalogProvider),
        data: (catalog) {
          final routine = catalog.routine(routineId);
          if (routine == null) return Center(child: Text(l10n.notFound));
          final safetyNotes = {
            for (final s in routine.steps)
              ...catalog.exerciseFor(s).safetyNotes,
          };
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
            children: [
              RoutineImage(catalog: catalog, routine: routine),
              const SizedBox(height: AppSpacing.lg),
              if (catalog.isPreviewOnly(routine)) ...[
                const DemoBanner(),
                const SizedBox(height: AppSpacing.md),
              ],
              Text(routine.title, style: theme.textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.routineMeta(catalog, routine),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.appColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(routine.description),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.detailStepsHeader(routine.steps.length),
                style: theme.textTheme.titleLarge,
              ),
              for (final step in routine.steps)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  // Opens "Tìm hiểu" when the exercise has a story (D17).
                  onTap: learn?.storyFor(step.exerciseId) == null
                      ? null
                      : () => context.push(
                          AppRoutes.exerciseLearn(step.exerciseId),
                        ),
                  trailing: learn?.storyFor(step.exerciseId) == null
                      ? null
                      : Icon(
                          Icons.menu_book_outlined,
                          semanticLabel: l10n.learnHeader,
                        ),
                  leading: SizedBox(
                    width: IconSizes.listThumbnail,
                    child: ExerciseImage(
                      path: catalog.thumbnailOf(catalog.exerciseFor(step)),
                      semanticLabel: '',
                      aspectRatio: 1,
                    ),
                  ),
                  title: Text(
                    l10n.detailStepItem(
                      step.order.toString().padLeft(2, '0'),
                      catalog.exerciseFor(step).title,
                      l10n.durationMinutes(step.duration),
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.detailSafetyHeader, style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              for (final note in safetyNotes)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Text('• $note'),
                ),
              const SizedBox(height: AppSpacing.sm),
              _StopWarning(text: l10n.stopWarning),
              const SizedBox(height: AppSpacing.xl),
              switch (available) {
                AsyncData(value: true) => FilledButton.icon(
                  onPressed: () => context.push(AppRoutes.preflight(routineId)),
                  icon: const Icon(Icons.play_arrow),
                  label: Text(l10n.detailStartAction),
                ),
                AsyncData(value: false) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l10n.needsDownloadExplanation),
                    const SizedBox(height: AppSpacing.sm),
                    FilledButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.download),
                      label: Text(l10n.needsDownload),
                    ),
                  ],
                ),
                _ => const Center(child: CircularProgressIndicator()),
              },
            ],
          );
        },
      ),
    );
  }
}

class _StopWarning extends StatelessWidget {
  const _StopWarning({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.warning_amber_rounded, color: colors.danger),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(text)),
      ],
    );
  }
}
