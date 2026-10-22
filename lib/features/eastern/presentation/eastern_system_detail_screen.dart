import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/component_tokens.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../../../core/ui/async_value_view.dart';
import '../../catalog/application/catalog_providers.dart';
import '../../catalog/domain/catalog_models.dart';
import '../../learn/application/learn_providers.dart';
import '../../learn/presentation/learn_widgets.dart';
import '../application/eastern_providers.dart';
import '../domain/practice_system.dart';
import 'eastern_labels.dart';
import 'eastern_widgets.dart';

/// Introduction of one system: names of the forms, notes, safety and sources.
/// Deliberately has no Start/Download action until reviewed media exists.
class EasternSystemDetailScreen extends ConsumerWidget {
  const EasternSystemDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.easternTitle)),
      body: AsyncValueView(
        value: ref.watch(easternSystemsProvider),
        onRetry: () => ref.invalidate(easternSystemsProvider),
        data: (systems) {
          final system = systems.where((s) => s.slug == slug).firstOrNull;
          if (system == null) return Center(child: Text(l10n.notFound));
          final learn = ref.watch(culturalContentProvider).value;
          final profile = learn?.profileFor(system.slug);
          return _Detail(
            system: system,
            catalog: ref.watch(catalogProvider).value,
            history: profile == null
                ? null
                : SystemProfileSection(
                    profile: profile,
                    references: learn!.referencesFor(profile.sourceIds),
                  ),
          );
        },
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({
    required this.system,
    required this.catalog,
    required this.history,
  });

  final PracticeSystem system;

  /// History and culture (D17), when the cultural pack covers the system.
  final Widget? history;

  /// App catalog: published routines/exercises of this system become playable.
  final ContentCatalog? catalog;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final secondary = theme.textTheme.bodyMedium?.copyWith(
      color: theme.appColors.textSecondary,
    );
    Widget header(String text) => Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.sm),
      child: Text(text, style: theme.textTheme.titleLarge),
    );
    Widget bullet(String text) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text('• $text'),
    );
    final routine = system.playableRoutine(catalog);
    final meta = [
      if (!system.researchOnly) l10n.easternFormCount(system.formCount),
      ?l10n.easternLevel(system.level),
    ].join(' · ');

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
      children: [
        Center(
          child: EasternCover(
            assetKey: system.coverAssetKey,
            semanticLabel: l10n.easternCoverLabel(system.titleVi),
            width: EasternTokens.detailCoverWidth,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.easternCoverNotice,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.appColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(system.titleVi, style: theme.textTheme.headlineSmall),
        Text(system.titleOriginal, style: secondary),
        if (meta.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(meta, style: theme.textTheme.bodyLarge),
        ],
        const SizedBox(height: AppSpacing.md),
        EasternStatusLabel(
          text: l10n.easternStatus(system, playable: routine != null),
          playable: routine != null,
        ),
        const SizedBox(height: AppSpacing.sm),
        if (routine != null)
          FilledButton.icon(
            onPressed: () => context.push(AppRoutes.routine(routine.id)),
            icon: const Icon(Icons.play_arrow),
            label: Text(l10n.easternPracticeAction(system.titleVi)),
          )
        else
          Text(l10n.easternIntro),
        if (system.notes case final notes?) ...[
          header(l10n.easternNotesHeader),
          Text(notes),
        ],
        ?history,
        if (system.overviewBoards.isNotEmpty) ...[
          header(l10n.easternOverviewHeader),
          EasternNotice(text: l10n.easternOverviewNotice),
          for (final board in system.overviewBoards)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: EasternCover(
                assetKey: board.assetKey,
                semanticLabel: '',
                width: EasternTokens.listCoverWidth,
              ),
              title: Text(board.title),
              subtitle: Text(l10n.easternOverviewOpen),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(
                AppRoutes.easternOverview(system.slug, board.id),
              ),
            ),
        ],
        if (system.forms.isNotEmpty) ...[
          header(l10n.easternFormsHeader),
          for (final form in system.forms)
            Builder(
              builder: (context) {
                final published = catalog?.exerciseById(form.exerciseId);
                final image = published != null
                    ? catalog!.thumbnailOf(published)
                    : form.illustrationKey;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: image == null
                      ? null
                      : EasternCover(
                          assetKey: image,
                          semanticLabel: '',
                          width: EasternTokens.formThumbnailWidth,
                        ),
                  title: Text(l10n.easternFormItem(form.number, form.titleVi)),
                  subtitle: Text(form.originalName),
                  trailing: image == null
                      ? null
                      : const Icon(Icons.chevron_right),
                  onTap: image == null
                      ? null
                      : () => context.push(
                          AppRoutes.easternForm(system.slug, form.exerciseId),
                        ),
                );
              },
            ),
        ],
        if (system.requiredBeforeAuthoring.isNotEmpty) ...[
          header(l10n.easternRequiredHeader),
          for (final item in system.requiredBeforeAuthoring) bullet(item),
        ],
        header(l10n.detailSafetyHeader),
        for (final note in system.safetyNotes) bullet(note),
        bullet(l10n.stopWarning),
        if (system.sources.isNotEmpty) ...[
          header(l10n.easternSourcesHeader),
          for (final source in system.sources)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: SelectableText(source, style: secondary),
            ),
        ],
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
