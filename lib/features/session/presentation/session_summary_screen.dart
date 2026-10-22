import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../../../core/ui/async_value_view.dart';
import '../../catalog/application/catalog_providers.dart';
import '../../catalog/presentation/catalog_labels.dart';
import '../application/session_providers.dart';
import '../domain/workout_session.dart';

class SessionSummaryScreen extends ConsumerWidget {
  const SessionSummaryScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: AsyncValueView(
          value: ref.watch(sessionByIdProvider(sessionId)),
          onRetry: () => ref.invalidate(sessionByIdProvider(sessionId)),
          data: (session) {
            if (session == null) return Center(child: Text(l10n.notFound));
            final completed = session.status == WorkoutStatus.completed;
            final title = ref
                .watch(catalogProvider)
                .value
                ?.routine(session.routineId)
                ?.title;
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
              children: [
                const SizedBox(height: AppSpacing.xxl),
                Icon(
                  completed
                      ? Icons.check_circle_outline
                      : Icons.pause_circle_outline,
                  size: IconTheme.of(context).size! * 3,
                  color: completed
                      ? theme.appColors.success
                      : theme.appColors.textSecondary,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  completed
                      ? l10n.summaryCompletedTitle
                      : l10n.summaryEndedTitle,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                if (title != null) Text(title, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.summaryActive(
                    l10n.durationMinutesSeconds(session.activeTime),
                  ),
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  completed
                      ? l10n.summaryCompletedMessage
                      : l10n.summaryEndedMessage,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxl),
                FilledButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: Text(l10n.summaryHome),
                ),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton(
                  onPressed: () => context.go(AppRoutes.progress),
                  child: Text(l10n.summaryProgress),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
