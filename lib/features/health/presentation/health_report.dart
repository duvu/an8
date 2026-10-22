import 'package:an_brand/an_brand.dart';
import 'package:flutter/material.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/theme/component_tokens.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../domain/health_assessment.dart';
import '../domain/health_metric.dart';
import '../domain/measurement.dart';
import 'health_labels.dart';
import 'health_widgets.dart';

/// One-page summary rendered to PNG (D19): latest reading of every metric,
/// BMI, and a trend chart per metric with 2+ readings. Always the light
/// theme so it prints and reads well on any screen.
class HealthReport extends StatelessWidget {
  const HealthReport({
    super.key,
    required this.readings,
    required this.createdAt,
  });

  /// Newest first, per metric.
  final Map<HealthMetric, List<Measurement>> readings;
  final DateTime createdAt;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light,
      child: Builder(builder: _content),
    );
  }

  Widget _content(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final material = MaterialLocalizations.of(context);
    final secondary = theme.textTheme.bodyMedium?.copyWith(
      color: theme.appColors.textSecondary,
    );
    final latest = {
      for (final m in healthMetricOrder) m: ?readings[m]?.firstOrNull,
    };
    final (w, h) = (latest[HealthMetric.weight], latest[HealthMetric.height]);
    final bmiValue = w == null || h == null
        ? null
        : bmi(weightKg: w.value, heightCm: h.value);

    return ColoredBox(
      color: theme.appColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const AnLockup(height: BrandTokens.appBarLockupHeight),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.healthReportTitle, style: theme.textTheme.headlineSmall),
            Text(
              l10n.healthReportCreated(
                material.formatShortDate(createdAt),
                material.formatTimeOfDay(TimeOfDay.fromDateTime(createdAt)),
              ),
              style: secondary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.healthReportLatest, style: theme.textTheme.titleLarge),
            for (final MapEntry(key: metric, value: r) in latest.entries)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n.metricName(metric)}: ${l10n.readingText(r)}',
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      [
                        formatMeasuredAt(context, r.measuredAt),
                        if (metric.hasReferenceRange)
                          l10n.status(assess(r).level),
                      ].join(' · '),
                      style: secondary,
                    ),
                  ],
                ),
              ),
            if (bmiValue != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  '${l10n.bmiTitle}: ${formatHealthNumber(bmiValue, 1)} · '
                  '${l10n.bmiCategoryText(bmiCategory(bmiValue))}',
                  style: theme.textTheme.titleMedium,
                ),
              ),
            if (readings.values.any((r) => r.length >= 2)) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.healthReportTrends, style: theme.textTheme.titleLarge),
              for (final metric in healthMetricOrder)
                if ((readings[metric]?.length ?? 0) >= 2) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '${l10n.metricName(metric)} (${l10n.metricUnit(metric)})',
                    style: theme.textTheme.titleMedium,
                  ),
                  if (metric.hasSecondValue)
                    Text(
                      '${l10n.healthSystolicField} · ${l10n.healthDiastolicField}',
                      style: secondary,
                    ),
                  HealthChart(readings: readings[metric]!),
                  // Every plotted figure in words: the chart may skip labels
                  // where points crowd.
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.xs,
                    children: [
                      for (final r
                          in readings[metric]!
                              .take(HealthTokens.chartMaxPoints)
                              .toList()
                              .reversed)
                        Text(
                          '${material.formatShortDate(r.measuredAt)}: '
                          '${l10n.readingValue(r)}',
                          style: secondary,
                        ),
                    ],
                  ),
                ],
            ],
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.healthDisclaimer, style: secondary),
          ],
        ),
      ),
    );
  }
}
