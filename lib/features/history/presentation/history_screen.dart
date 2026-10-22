import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../../../core/ui/async_value_view.dart';
import '../../catalog/application/catalog_providers.dart';
import '../../catalog/domain/catalog_models.dart';
import '../../catalog/presentation/catalog_labels.dart';
import '../../session/application/session_providers.dart';
import '../../session/domain/workout_session.dart';

/// S09. Local history; incomplete sessions are labelled, never counted as completed.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final titles = {
      for (final r
          in ref.watch(catalogProvider).value?.routines ?? const <Routine>[])
        r.id: r.title,
    };
    return Scaffold(
      appBar: AppBar(title: Text(l10n.progressTitle)),
      body: AsyncValueView(
        value: ref.watch(sessionsProvider),
        onRetry: () => ref.invalidate(sessionsProvider),
        data: (sessions) {
          if (sessions.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(l10n.progressEmpty, textAlign: TextAlign.center),
              ),
            );
          }
          final total = sessions.fold(
            Duration.zero,
            (sum, s) => sum + s.activeTime,
          );
          final completed = sessions
              .where((s) => s.status == WorkoutStatus.completed)
              .length;
          final material = MaterialLocalizations.of(context);
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
            children: [
              Text(
                l10n.progressTotal(l10n.durationMinutesSeconds(total)),
                style: theme.textTheme.titleLarge,
              ),
              Text(l10n.progressCounts(sessions.length, completed)),
              const SizedBox(height: AppSpacing.lg),
              for (final s in sessions)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    _icon(s.status),
                    color: s.status == WorkoutStatus.completed
                        ? theme.appColors.success
                        : theme.appColors.textSecondary,
                  ),
                  title: Text(titles[s.routineId] ?? s.routineId),
                  subtitle: Text(
                    l10n.historyItemSubtitle(
                      '${material.formatShortDate(s.startedAt)} '
                      '${material.formatTimeOfDay(TimeOfDay.fromDateTime(s.startedAt))}',
                      _label(l10n, s.status),
                      l10n.durationMinutesSeconds(s.activeTime),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  static IconData _icon(WorkoutStatus status) => switch (status) {
    WorkoutStatus.completed => Icons.check_circle_outline,
    WorkoutStatus.inProgress => Icons.play_circle_outline,
    WorkoutStatus.abandoned ||
    WorkoutStatus.interrupted => Icons.pause_circle_outline,
  };

  static String _label(AppLocalizations l10n, WorkoutStatus status) =>
      switch (status) {
        WorkoutStatus.completed => l10n.statusCompleted,
        WorkoutStatus.abandoned => l10n.statusAbandoned,
        WorkoutStatus.interrupted => l10n.statusInterrupted,
        WorkoutStatus.inProgress => l10n.statusInProgress,
      };
}
