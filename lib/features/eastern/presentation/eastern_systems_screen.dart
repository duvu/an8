import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/component_tokens.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../../../core/ui/async_value_view.dart';
import '../../catalog/application/catalog_providers.dart';
import '../../learn/application/learn_providers.dart';
import '../application/eastern_providers.dart';
import 'eastern_labels.dart';
import 'eastern_widgets.dart';

/// List of eastern practice systems (introductions; no Start action).
class EasternSystemsScreen extends ConsumerWidget {
  const EasternSystemsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final catalog = ref.watch(catalogProvider).value;
    final episodes =
        ref.watch(culturalContentProvider).value?.episodes ?? const [];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.easternTitle)),
      body: AsyncValueView(
        value: ref.watch(easternSystemsProvider),
        onRetry: () => ref.invalidate(easternSystemsProvider),
        data: (systems) => ListView(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          children: [
            Text(l10n.easternIntro, style: theme.textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.lg),
            for (final system in systems)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () =>
                        context.push(AppRoutes.easternSystem(system.slug)),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EasternCover(
                            assetKey: system.coverAssetKey,
                            semanticLabel: l10n.easternCoverLabel(
                              system.titleVi,
                            ),
                            width: EasternTokens.listCoverWidth,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  system.titleVi,
                                  style: theme.textTheme.titleLarge,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  system.summary ??
                                      l10n.easternFormCount(system.formCount),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.appColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                EasternStatusLabel(
                                  text: l10n.easternStatus(
                                    system,
                                    playable:
                                        system.playableRoutine(catalog) != null,
                                  ),
                                  playable:
                                      system.playableRoutine(catalog) != null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            // Read-only stories; no Play until a recording is approved (D17).
            if (episodes.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Text(l10n.learnStoriesHeader, style: theme.textTheme.titleLarge),
              for (final episode in episodes)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.menu_book_outlined),
                  title: Text(episode.title),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.storyEpisode(episode.id)),
                ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ],
        ),
      ),
    );
  }
}
