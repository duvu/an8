import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../../../core/ui/async_value_view.dart';
import '../../catalog/application/catalog_providers.dart';
import '../../catalog/domain/catalog_models.dart';
import '../../catalog/presentation/exercise_image.dart';
import '../../learn/application/learn_providers.dart';
import '../../learn/presentation/learn_widgets.dart';
import '../application/eastern_providers.dart';
import 'eastern_widgets.dart';

/// One form: its published steps (D13), or else its draft illustration card
/// with an explicit "do not practise from this image" notice (D11).
class EasternFormScreen extends ConsumerWidget {
  const EasternFormScreen({
    super.key,
    required this.slug,
    required this.exerciseId,
  });

  final String slug;
  final String exerciseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.easternTitle)),
      body: AsyncValueView(
        value: ref.watch(easternSystemsProvider),
        onRetry: () => ref.invalidate(easternSystemsProvider),
        data: (systems) {
          final system = systems.where((s) => s.slug == slug).firstOrNull;
          final form = system?.forms
              .where((f) => f.exerciseId == exerciseId)
              .firstOrNull;
          final learn = ref.watch(culturalContentProvider).value;
          final story = learn?.storyFor(exerciseId);
          final learnSection = story == null
              ? null
              : ExerciseLearnSection(
                  story: story,
                  references: learn!.referencesFor(story.sourceIds),
                );
          final published = form == null
              ? null
              : ref.watch(catalogProvider).value?.exerciseById(form.exerciseId);
          if (system != null && form != null && published != null) {
            return _PublishedSteps(
              title: l10n.easternFormItem(form.number, form.titleVi),
              subtitle: '${system.titleVi} · ${form.originalName}',
              exercise: published,
              learn: learnSection,
            );
          }
          final key = form?.illustrationKey;
          if (system == null || form == null || key == null) {
            return Center(child: Text(l10n.notFound));
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
            children: [
              Text(
                l10n.easternFormItem(form.number, form.titleVi),
                style: theme.textTheme.headlineSmall,
              ),
              Text(
                '${system.titleVi} · ${form.originalName}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.appColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              EasternNotice(text: l10n.easternFormIllustrationNotice),
              const SizedBox(height: AppSpacing.md),
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(AppRadius.md),
                ),
                child: Image.asset(
                  key,
                  fit: BoxFit.contain,
                  semanticLabel: l10n.easternFormIllustrationLabel(
                    form.titleVi,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(l10n.stopWarning),
              ?learnSection,
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }
}

/// A published form (D13): its real instruction steps, as in the Player.
class _PublishedSteps extends StatelessWidget {
  const _PublishedSteps({
    required this.title,
    required this.subtitle,
    required this.exercise,
    required this.learn,
  });

  final String title;
  final String subtitle;
  final Exercise exercise;
  final Widget? learn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
      children: [
        Text(title, style: theme.textTheme.headlineSmall),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.appColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.easternStepsHeader, style: theme.textTheme.titleLarge),
        for (final step in exercise.steps) ...[
          const SizedBox(height: AppSpacing.md),
          ExerciseImage(
            path: step.framePath,
            semanticLabel: step.instruction,
            aspectRatio: 1,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${step.order}. ${step.instruction}',
            style: theme.textTheme.bodyLarge,
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        Text(l10n.detailSafetyHeader, style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.sm),
        for (final note in exercise.safetyNotes)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Text('• $note'),
          ),
        ?learn,
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
