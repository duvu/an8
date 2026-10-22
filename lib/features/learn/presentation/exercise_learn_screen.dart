import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../../../core/ui/async_value_view.dart';
import '../application/learn_providers.dart';
import 'learn_widgets.dart';

/// "Tìm hiểu" of one exercise, opened from a routine's step list.
class ExerciseLearnScreen extends ConsumerWidget {
  const ExerciseLearnScreen({super.key, required this.exerciseId});

  final String exerciseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.learnHeader)),
      body: AsyncValueView(
        value: ref.watch(culturalContentProvider),
        onRetry: () => ref.invalidate(culturalContentProvider),
        data: (content) {
          final story = content.storyFor(exerciseId);
          if (story == null) return Center(child: Text(l10n.notFound));
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
            children: [
              Text(story.title, style: theme.textTheme.headlineSmall),
              ExerciseLearnSection(
                story: story,
                references: content.referencesFor(story.sourceIds),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          );
        },
      ),
    );
  }
}
