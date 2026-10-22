import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../../../core/clock/clock_provider.dart';
import '../../../core/ui/async_value_view.dart';
import '../application/health_export.dart';
import '../application/health_providers.dart';
import '../domain/health_csv.dart';
import 'health_labels.dart';
import 'health_report.dart';

/// Export as CSV (all readings) or PNG (the summary previewed below).
class HealthExportScreen extends ConsumerStatefulWidget {
  const HealthExportScreen({super.key});

  @override
  ConsumerState<HealthExportScreen> createState() => _HealthExportScreenState();
}

class _HealthExportScreenState extends ConsumerState<HealthExportScreen> {
  final _report = GlobalKey();
  bool _busy = false;

  Future<void> _run(Future<void> Function(AppLocalizations l10n) work) async {
    if (_busy) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      await work(l10n);
    } on Exception {
      messenger.showSnackBar(SnackBar(content: Text(l10n.healthExportFailed)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _exportCsv(AppLocalizations l10n) => ref
      .read(healthExporterProvider)
      .exportCsv(
        CsvLabels(
          header: [
            l10n.csvMeasuredAt,
            l10n.csvMetric,
            l10n.csvValue,
            l10n.csvSecondValue,
            l10n.csvUnit,
            l10n.csvGlucoseTiming,
            l10n.csvNote,
          ],
          metricName: l10n.metricName,
          metricUnit: l10n.metricUnit,
          glucoseTiming: l10n.glucoseTiming,
        ),
        subject: l10n.healthExportSubject,
      );

  Future<void> _exportImage(AppLocalizations l10n) async {
    final boundary =
        _report.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    if (bytes == null) throw const FormatException('PNG encoding failed');
    await ref
        .read(healthExporterProvider)
        .exportPng(
          bytes.buffer.asUint8List(),
          subject: l10n.healthExportSubject,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final secondary = theme.textTheme.bodyMedium?.copyWith(
      color: theme.appColors.textSecondary,
    );
    return Scaffold(
      appBar: AppBar(title: Text(l10n.healthExportTitle)),
      body: AsyncValueView(
        value: ref.watch(allByMetricProvider),
        onRetry: () => ref.invalidate(allByMetricProvider),
        data: (readings) => ListView(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          children: [
            Text(l10n.healthExportIntro, style: theme.textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.healthExportPrivacy, style: secondary),
            const SizedBox(height: AppSpacing.xl),
            if (readings.isEmpty)
              Text(l10n.healthExportEmpty)
            else ...[
              FilledButton.icon(
                onPressed: _busy ? null : () => _run(_exportCsv),
                icon: const Icon(Icons.table_view_outlined),
                label: Text(l10n.healthExportCsv),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(l10n.healthExportCsvHint, style: secondary),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: _busy ? null : () => _run(_exportImage),
                icon: const Icon(Icons.image_outlined),
                label: Text(l10n.healthExportImage),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(l10n.healthExportImageHint, style: secondary),
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.healthExportPreview, style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.appColors.border),
                ),
                child: RepaintBoundary(
                  key: _report,
                  child: HealthReport(
                    readings: readings,
                    createdAt: ref.read(appClockProvider).now(),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ],
        ),
      ),
    );
  }
}
