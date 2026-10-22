import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/component_tokens.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../domain/health_assessment.dart';
import '../domain/measurement.dart';
import 'health_labels.dart';

/// Status as icon + words (never colour alone).
class AssessmentBadge extends StatelessWidget {
  const AssessmentBadge({super.key, required this.level});

  final AssessmentLevel level;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final (icon, color) = switch (level) {
      AssessmentLevel.inRange => (Icons.check_circle_outline, colors.success),
      AssessmentLevel.outside => (Icons.info_outline, colors.warning),
      AssessmentLevel.urgent => (Icons.warning_amber, colors.danger),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        const SizedBox(width: AppSpacing.xs),
        Flexible(
          child: Text(
            AppLocalizations.of(context).status(level),
            style: TextStyle(color: color),
          ),
        ),
      ],
    );
  }
}

/// Bordered notice for reference text, weight loss and alerts.
class HealthNotice extends StatelessWidget {
  const HealthNotice({super.key, required this.text, this.urgent = false});

  final String text;
  final bool urgent;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final accent = urgent ? colors.danger : colors.warning;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        border: Border.all(color: accent),
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.sm)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            urgent ? Icons.warning_amber : Icons.info_outline,
            color: accent,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

/// Line chart of the newest readings, oldest left. Points sit at their real
/// time (uneven gaps stay uneven) and every value is written on the chart.
/// Blood pressure draws systolic (accent, label above) and diastolic
/// (secondary, label below). The list below the chart is the accessible
/// version; the chart itself has one summary label.
class HealthChart extends StatelessWidget {
  const HealthChart({super.key, required this.readings});

  /// Newest first, as the repository returns them.
  final List<Measurement> readings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).appColors;
    final scaler = MediaQuery.textScalerOf(context);
    final material = MaterialLocalizations.of(context);
    final points = readings
        .take(HealthTokens.chartMaxPoints)
        .toList()
        .reversed
        .toList();
    final metric = readings.first.metric;
    final labelStyle = AppTypography.auxiliary.copyWith(
      color: colors.textPrimary,
    );
    final dateStyle = AppTypography.auxiliary.copyWith(
      color: colors.textSecondary,
    );
    final rowHeight = scaler.scale(
      AppTypography.auxiliary.fontSize! * (AppTypography.auxiliary.height ?? 1),
    );
    return Semantics(
      image: true,
      label: l10n.healthChartLabel(
        l10n.metricName(metric),
        readings.length,
        l10n.readingText(readings.first),
      ),
      child: ExcludeSemantics(
        child: SizedBox(
          // Plot + value rows above/below + date row.
          height: HealthTokens.chartHeight + rowHeight * 3,
          width: double.infinity,
          child: CustomPaint(
            painter: _ChartPainter(
              times: [for (final r in points) r.measuredAt],
              series: [
                [for (final r in points) r.value],
                if (metric.hasSecondValue)
                  [for (final r in points) r.secondValue!],
              ],
              decimals: metric.decimals,
              dates: [
                for (final r in points) material.formatShortDate(r.measuredAt),
              ],
              colors: [colors.accent, colors.textSecondary],
              grid: colors.border,
              labelStyle: labelStyle,
              dateStyle: dateStyle,
              textScaler: scaler,
              rowHeight: rowHeight,
              textDirection: Directionality.of(context),
            ),
          ),
        ),
      ),
    );
  }
}

/// Position of [at] between [first] and [last] as 0..1 (0.5 when they are the
/// same instant), so uneven gaps between readings stay uneven on the chart.
@visibleForTesting
double chartTimeFraction(DateTime at, DateTime first, DateTime last) {
  final span = last.millisecondsSinceEpoch - first.millisecondsSinceEpoch;
  if (span == 0) return 0.5;
  return (at.millisecondsSinceEpoch - first.millisecondsSinceEpoch) / span;
}

class _ChartPainter extends CustomPainter {
  _ChartPainter({
    required this.times,
    required this.series,
    required this.decimals,
    required this.dates,
    required this.colors,
    required this.grid,
    required this.labelStyle,
    required this.dateStyle,
    required this.textScaler,
    required this.rowHeight,
    required this.textDirection,
  });

  final List<DateTime> times;
  final List<List<double>> series;
  final int decimals;
  final List<String> dates;
  final List<Color> colors;
  final Color grid;
  final TextStyle labelStyle;
  final TextStyle dateStyle;
  final TextScaler textScaler;
  final double rowHeight;
  final TextDirection textDirection;

  TextPainter _text(String text, TextStyle style) => TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: textDirection,
    textScaler: textScaler,
    maxLines: 1,
  )..layout();

  @override
  void paint(Canvas canvas, Size size) {
    final all = series.expand((s) => s);
    var low = all.reduce(math.min);
    var high = all.reduce(math.max);
    final pad = math.max((high - low) * 0.15, 1.0);
    low -= pad;
    high += pad;
    const inset = HealthTokens.chartPointRadius * 2;
    final area = Rect.fromLTRB(
      inset,
      rowHeight + inset,
      size.width - inset,
      size.height - rowHeight * 2 - inset,
    );

    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (var i = 0; i <= 2; i++) {
      final y = area.top + area.height * i / 2;
      canvas.drawLine(Offset(area.left, y), Offset(area.right, y), gridPaint);
    }

    // Time axis: x is proportional to the real gap between readings.
    double xAt(int i) =>
        area.left +
        area.width * chartTimeFraction(times[i], times.first, times.last);
    Offset at(List<double> values, int i) => Offset(
      xAt(i),
      area.bottom - area.height * (values[i] - low) / (high - low),
    );

    for (var s = 0; s < series.length; s++) {
      final values = series[s];
      final line = Paint()
        ..color = colors[s]
        ..strokeWidth = HealthTokens.chartStrokeWidth
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round;
      final path = Path()..moveTo(at(values, 0).dx, at(values, 0).dy);
      for (var i = 1; i < values.length; i++) {
        path.lineTo(at(values, i).dx, at(values, i).dy);
      }
      canvas.drawPath(path, line);
      final dot = Paint()..color = colors[s];
      for (var i = 0; i < values.length; i++) {
        canvas.drawCircle(at(values, i), HealthTokens.chartPointRadius, dot);
      }
    }

    // Values: newest first so a crowded chart keeps the latest readings.
    final taken = <Rect>[];
    Rect? place(TextPainter tp, double cx, double top) {
      final left = (cx - tp.width / 2).clamp(0.0, size.width - tp.width);
      final box = Rect.fromLTWH(left, top, tp.width, tp.height);
      if (taken.any((r) => r.inflate(2).overlaps(box))) return null;
      taken.add(box);
      return box;
    }

    for (var s = 0; s < series.length; s++) {
      final below = s == 1;
      for (var i = times.length - 1; i >= 0; i--) {
        final point = at(series[s], i);
        final tp = _text(
          formatHealthNumber(series[s][i], decimals),
          labelStyle,
        );
        final top = below
            ? point.dy + HealthTokens.chartPointRadius
            : point.dy - HealthTokens.chartPointRadius - tp.height;
        final box = place(tp, point.dx, top);
        if (box != null) tp.paint(canvas, box.topLeft);
      }
    }

    // Dates under the axis: oldest and newest only (skipped if they collide).
    final dateTop = size.height - rowHeight;
    final last = times.length - 1;
    final newest = _text(dates[last], dateStyle);
    final newestBox = place(newest, xAt(last), dateTop);
    if (newestBox != null) newest.paint(canvas, newestBox.topLeft);
    if (last > 0 && dates[0] != dates[last]) {
      final oldest = _text(dates[0], dateStyle);
      final oldestBox = place(oldest, xAt(0), dateTop);
      if (oldestBox != null) oldest.paint(canvas, oldestBox.topLeft);
    }
  }

  @override
  bool shouldRepaint(_ChartPainter old) =>
      old.times != times ||
      old.series != series ||
      old.dates != dates ||
      old.colors != colors ||
      old.grid != grid ||
      old.textScaler != textScaler ||
      old.labelStyle != labelStyle;
}
