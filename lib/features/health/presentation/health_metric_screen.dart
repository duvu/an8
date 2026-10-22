import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../../../core/ui/async_value_view.dart';
import '../application/health_providers.dart';
import '../domain/health_assessment.dart';
import '../domain/health_metric.dart';
import '../domain/measurement.dart';
import 'health_labels.dart';
import 'health_widgets.dart';

/// One metric over time: reference, chart, every reading (deletable).
class HealthMetricScreen extends ConsumerWidget {
  const HealthMetricScreen({super.key, required this.metricName});

  final String metricName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final metric = HealthMetric.values.asNameMap()[metricName];
    if (metric == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.notFound)),
      );
    }
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.metricName(metric))),
      body: AsyncValueView(
        value: ref.watch(readingsProvider(metric)),
        onRetry: () => ref.invalidate(readingsProvider(metric)),
        data: (readings) => ListView(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          children: [
            FilledButton.icon(
              onPressed: () => context.push(AppRoutes.healthAdd(metric.name)),
              icon: const Icon(Icons.add),
              label: Text(l10n.healthAddAction),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.reference(metric), style: theme.textTheme.bodyLarge),
            if (metric.hasReferenceRange) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.referenceSource,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.appColors.textSecondary,
                ),
              ),
            ],
            if (metric == HealthMetric.weight &&
                significantWeightLoss(readings)) ...[
              const SizedBox(height: AppSpacing.md),
              HealthNotice(text: l10n.weightLossNotice),
            ],
            if (readings.length >= 2) ...[
              const SizedBox(height: AppSpacing.lg),
              HealthChart(readings: readings),
            ],
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.healthHistoryHeader, style: theme.textTheme.titleLarge),
            if (readings.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(l10n.healthNoReading),
              ),
            for (final reading in readings) _ReadingTile(reading: reading),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.healthDisclaimer,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.appColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _ReadingTile extends ConsumerWidget {
  const _ReadingTile({required this.reading});

  final Measurement reading;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.healthDeleteReadingConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.healthCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.healthDeleteConfirmAction),
          ),
        ],
      ),
    );
    if (ok == true) await ref.read(healthActionsProvider).delete(reading.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final note = reading.note;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        l10n.readingText(reading),
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(formatMeasuredAt(context, reading.measuredAt)),
          if (reading.metric.hasReferenceRange)
            AssessmentBadge(level: assess(reading).level),
          ?(note == null ? null : Text(note)),
        ],
      ),
      trailing: IconButton(
        tooltip: l10n.healthDeleteReading,
        icon: const Icon(Icons.delete_outline),
        onPressed: () => _confirmDelete(context, ref),
      ),
    );
  }
}
