import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../../../core/ui/async_value_view.dart';
import '../../settings/application/preferences_controller.dart';
import '../application/health_providers.dart';
import '../domain/health_assessment.dart';
import '../domain/health_metric.dart';
import '../domain/measurement.dart';
import 'health_labels.dart';
import 'health_widgets.dart';

/// Health tab (D18): consent first, then the latest reading of every metric.
class HealthScreen extends ConsumerWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final consent = ref.watch(
      preferencesProvider.select((p) => p.healthConsent),
    );
    return Scaffold(
      appBar: AppBar(title: Text(l10n.healthTitle)),
      body: consent
          ? AsyncValueView(
              value: ref.watch(latestReadingsProvider),
              onRetry: () => ref.invalidate(latestReadingsProvider),
              data: (latest) => _Overview(latest: latest),
            )
          : const _Consent(),
    );
  }
}

class _Consent extends ConsumerWidget {
  const _Consent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    Widget point(IconData icon, String text) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.appColors.accent),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(text, style: theme.textTheme.bodyLarge)),
        ],
      ),
    );
    return Column(
      children: [
        Expanded(child: _consentText(l10n, theme, point)),
        // Pinned under the explanation, never below the fold.
        Padding(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => ref.read(healthActionsProvider).giveConsent(),
              child: Text(l10n.healthConsentAccept),
            ),
          ),
        ),
      ],
    );
  }

  Widget _consentText(
    AppLocalizations l10n,
    ThemeData theme,
    Widget Function(IconData, String) point,
  ) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
      children: [
        Text(l10n.healthConsentTitle, style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.sm),
        Text(l10n.healthConsentIntro, style: theme.textTheme.bodyLarge),
        const SizedBox(height: AppSpacing.xl),
        point(Icons.edit_note, l10n.healthConsentManual),
        point(Icons.phone_android, l10n.healthConsentLocal),
        point(Icons.delete_outline, l10n.healthConsentDelete),
        point(Icons.medical_services_outlined, l10n.healthConsentNoDiagnosis),
      ],
    );
  }
}

class _Overview extends ConsumerWidget {
  const _Overview({required this.latest});

  final Map<HealthMetric, Measurement> latest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final weights = ref.watch(readingsProvider(HealthMetric.weight)).value;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
      children: [
        FilledButton.icon(
          onPressed: () => context.push(AppRoutes.healthAdd()),
          icon: const Icon(Icons.add),
          label: Text(l10n.healthAddAction),
        ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: () => context.push(AppRoutes.healthExport),
          icon: const Icon(Icons.ios_share),
          label: Text(l10n.healthExportAction),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (weights != null && significantWeightLoss(weights)) ...[
          HealthNotice(text: l10n.weightLossNotice),
          const SizedBox(height: AppSpacing.md),
        ],
        _BmiCard(
          weight: latest[HealthMetric.weight],
          height: latest[HealthMetric.height],
        ),
        for (final metric in healthMetricOrder)
          _MetricCard(metric: metric, latest: latest[metric]),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.healthDisclaimer,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: Theme.of(context).appColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _BmiCard extends StatelessWidget {
  const _BmiCard({required this.weight, required this.height});

  final Measurement? weight;
  final Measurement? height;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final secondary = theme.textTheme.bodySmall?.copyWith(
      color: theme.appColors.textSecondary,
    );
    final (w, h) = (weight, height);
    final value = w == null || h == null
        ? null
        : bmi(weightKg: w.value, heightCm: h.value);
    String kg(double v) => formatHealthNumber(v, HealthMetric.weight.decimals);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.bmiTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            if (value == null)
              Text(h == null ? l10n.bmiNeedsBoth : l10n.bmiNeedsWeight)
            else ...[
              Text(
                formatHealthNumber(value, 1),
                style: theme.textTheme.headlineSmall,
              ),
              Text(l10n.bmiCategoryText(bmiCategory(value))),
            ],
            // Adult height barely changes, so the latest one gives a target.
            if (h != null) ...[
              const SizedBox(height: AppSpacing.md),
              _weightRange(l10n, theme, h.value, kg),
              if (w != null)
                ..._weightPosition(l10n, w.value, h.value, kg, secondary),
            ],
            if (value != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(l10n.bmiNote, style: secondary),
            ],
          ],
        ),
      ),
    );
  }

  Widget _weightRange(
    AppLocalizations l10n,
    ThemeData theme,
    double heightCm,
    String Function(double) kg,
  ) {
    final range = normalWeightRange(heightCm);
    return Text(
      l10n.bmiWeightRange(
        formatHealthNumber(heightCm, HealthMetric.height.decimals),
        kg(range.min),
        kg(range.max),
      ),
      style: theme.textTheme.titleMedium,
    );
  }

  List<Widget> _weightPosition(
    AppLocalizations l10n,
    double weightKg,
    double heightCm,
    String Function(double) kg,
    TextStyle? secondary,
  ) {
    final outside = weightOutsideNormal(weightKg: weightKg, heightCm: heightCm);
    return [
      Text(switch (outside) {
        > 0 => l10n.bmiWeightAbove(kg(outside)),
        < 0 => l10n.bmiWeightBelow(kg(-outside)),
        _ => l10n.bmiWeightInRange,
      }),
      if (outside != 0) Text(l10n.bmiWeightAdvice, style: secondary),
    ];
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric, required this.latest});

  final HealthMetric metric;
  final Measurement? latest;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final reading = latest;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        title: Text(l10n.metricName(metric), style: theme.textTheme.titleLarge),
        subtitle: reading == null
            ? Text(l10n.healthNoReading)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.readingText(reading),
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(formatMeasuredAt(context, reading.measuredAt)),
                  if (metric.hasReferenceRange)
                    AssessmentBadge(level: assess(reading).level),
                ],
              ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(AppRoutes.healthMetric(metric.name)),
      ),
    );
  }
}
