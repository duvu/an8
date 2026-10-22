import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../../../core/ui/async_value_view.dart';
import '../../catalog/application/catalog_providers.dart';
import '../../catalog/domain/catalog_models.dart';
import '../../catalog/presentation/catalog_labels.dart';
import '../../catalog/presentation/routine_card.dart';
import '../../eastern/application/eastern_providers.dart';
import '../application/library_providers.dart';
import '../domain/library_filter.dart';

/// S03. Search and filters over the catalog; demo content stays labelled.
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final filter = ref.watch(libraryFilterProvider);
    final controller = ref.read(libraryFilterProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.libraryTitle)),
      body: AsyncValueView(
        value: ref.watch(libraryDataProvider),
        onRetry: () => ref.invalidate(libraryDataProvider),
        data: (data) => ListView(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          children: [
            const _EasternEntry(),
            const SizedBox(height: AppSpacing.lg),
            _SearchField(
              query: filter.query,
              label: l10n.librarySearchHint,
              onChanged: (q) => controller.update((f) => f.copyWith(query: q)),
            ),
            const SizedBox(height: AppSpacing.md),
            _ChoiceGroup<String>(
              label: l10n.libraryFilterGoal,
              selected: filter.tag,
              options: {for (final t in data.tags) t: l10n.tag(t)},
              onSelected: (t) =>
                  controller.update((f) => f.copyWith(tag: () => t)),
            ),
            _ChoiceGroup<BodyPosition>(
              label: l10n.libraryFilterPosition,
              selected: filter.position,
              options: {
                for (final p in BodyPosition.values) p: l10n.position(p),
              },
              onSelected: (p) =>
                  controller.update((f) => f.copyWith(position: () => p)),
            ),
            _ChoiceGroup<DurationBucket>(
              label: l10n.libraryFilterDuration,
              selected: filter.duration,
              options: {
                DurationBucket.short: l10n.durationShort,
                DurationBucket.medium: l10n.durationMedium,
                DurationBucket.long: l10n.durationLong,
              },
              onSelected: (d) =>
                  controller.update((f) => f.copyWith(duration: () => d)),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.libraryOfflineOnly),
              value: filter.offlineOnly,
              onChanged: (v) =>
                  controller.update((f) => f.copyWith(offlineOnly: v)),
            ),
            const SizedBox(height: AppSpacing.sm),
            Semantics(
              liveRegion: true,
              child: Text(
                l10n.libraryResultCount(data.results.length),
                style: theme.textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (data.results.isEmpty) ...[
              Text(l10n.libraryEmpty),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton(
                onPressed: controller.clear,
                child: Text(l10n.libraryClearFilters),
              ),
            ],
            for (final routine in data.results)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: RoutineCard(
                  catalog: data.catalog,
                  routine: routine,
                  onOpen: () => context.push(AppRoutes.routine(routine.id)),
                  trailing: _AvailabilityLabel(
                    available: data.isAvailable(routine),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AvailabilityLabel extends StatelessWidget {
  const _AvailabilityLabel({required this.available});

  final bool available;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).appColors;
    return Row(
      children: [
        Icon(
          available ? Icons.offline_pin_outlined : Icons.download_outlined,
          color: available ? colors.success : colors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.xs),
        Flexible(
          child: Text(available ? l10n.availableOffline : l10n.needsDownload),
        ),
      ],
    );
  }
}

class _ChoiceGroup<T> extends StatelessWidget {
  const _ChoiceGroup({
    required this.label,
    required this.selected,
    required this.options,
    required this.onSelected,
  });

  final String label;
  final T? selected;
  final Map<T, String> options;
  final ValueChanged<T?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          // One scrollable row per filter keeps results near the top on phones.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: AppSpacing.sm,
              children: [
                ChoiceChip(
                  label: Text(l10n.libraryFilterAll),
                  selected: selected == null,
                  onSelected: (_) => onSelected(null),
                ),
                for (final MapEntry(:key, :value) in options.entries)
                  ChoiceChip(
                    label: Text(value),
                    selected: selected == key,
                    onSelected: (on) => onSelected(on ? key : null),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Keeps the text field in sync when filters are cleared elsewhere.
class _SearchField extends StatefulWidget {
  const _SearchField({
    required this.query,
    required this.label,
    required this.onChanged,
  });

  final String query;
  final String label;
  final ValueChanged<String> onChanged;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late final _controller = TextEditingController(text: widget.query);

  @override
  void didUpdateWidget(_SearchField old) {
    super.didUpdateWidget(old);
    if (widget.query != _controller.text) _controller.text = widget.query;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: _controller,
    decoration: InputDecoration(
      labelText: widget.label,
      prefixIcon: const Icon(Icons.search),
    ),
    onChanged: widget.onChanged,
  );
}

/// Entry to the eastern practice introductions (not part of the playable results).
class _EasternEntry extends ConsumerWidget {
  const _EasternEntry();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final systems = ref.watch(easternSystemsProvider).value;
    final catalog = ref.watch(catalogProvider).value;
    final playable = systems
        ?.where((s) => s.playableRoutine(catalog) != null)
        .length;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        leading: Icon(Icons.spa_outlined, color: theme.appColors.accent),
        title: Text(l10n.easternTitle, style: theme.textTheme.titleLarge),
        subtitle: systems == null
            ? null
            : Text(l10n.easternEntrySubtitle(systems.length, playable!)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(AppRoutes.eastern),
      ),
    );
  }
}
