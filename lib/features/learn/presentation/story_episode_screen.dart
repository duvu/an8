import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../../../core/ui/async_value_view.dart';
import '../application/learn_providers.dart';
import 'learn_widgets.dart';

/// A story to read. No Play button until an approved recording exists.
class StoryEpisodeScreen extends ConsumerWidget {
  const StoryEpisodeScreen({super.key, required this.episodeId});

  final String episodeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.learnStoriesHeader)),
      body: AsyncValueView(
        value: ref.watch(episodeProvider(episodeId)),
        onRetry: () => ref.invalidate(episodeProvider(episodeId)),
        data: (story) {
          if (story == null) return Center(child: Text(l10n.notFound));
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
            children: [
              Text(story.episode.title, style: theme.textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.lg),
              Text(story.text, style: theme.textTheme.bodyLarge),
              const SizedBox(height: AppSpacing.xl),
              const LearnDisclaimer(),
            ],
          );
        },
      ),
    );
  }
}
