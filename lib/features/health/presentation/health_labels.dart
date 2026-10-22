import 'package:flutter/material.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../domain/health_assessment.dart';
import '../domain/health_metric.dart';
import '../domain/measurement.dart';

/// Order on the Health screen: what older adults check most often first.
const healthMetricOrder = [
  HealthMetric.bloodPressure,
  HealthMetric.heartRate,
  HealthMetric.bloodGlucose,
  HealthMetric.weight,
  HealthMetric.height,
  HealthMetric.oxygenSaturation,
  HealthMetric.temperature,
  HealthMetric.waist,
];

/// Vietnamese number with a decimal comma: 3.9 → "3,9".
String formatHealthNumber(double value, int decimals) =>
    value.toStringAsFixed(decimals).replaceAll('.', ',');

extension HealthLabels on AppLocalizations {
  String metricName(HealthMetric m) => switch (m) {
    HealthMetric.weight => metricWeight,
    HealthMetric.height => metricHeight,
    HealthMetric.bloodPressure => metricBloodPressure,
    HealthMetric.heartRate => metricHeartRate,
    HealthMetric.bloodGlucose => metricBloodGlucose,
    HealthMetric.oxygenSaturation => metricOxygenSaturation,
    HealthMetric.temperature => metricTemperature,
    HealthMetric.waist => metricWaist,
  };

  String metricUnit(HealthMetric m) => switch (m) {
    HealthMetric.weight => unitKg,
    HealthMetric.height || HealthMetric.waist => unitCm,
    HealthMetric.bloodPressure => unitMmHg,
    HealthMetric.heartRate => unitBpm,
    HealthMetric.bloodGlucose => unitMmolL,
    HealthMetric.oxygenSaturation => unitPercent,
    HealthMetric.temperature => unitCelsius,
  };

  /// "128/82", "6,2" (no unit).
  String readingValue(Measurement r) {
    final d = r.metric.decimals;
    return r.metric.hasSecondValue
        ? '${formatHealthNumber(r.value, d)}/${formatHealthNumber(r.secondValue!, d)}'
        : formatHealthNumber(r.value, d);
  }

  /// "128/82 mmHg", "6,2 mmol/L · Lúc đói".
  String readingText(Measurement r) {
    final timing = r.glucoseTiming;
    return [
      '${readingValue(r)} ${metricUnit(r.metric)}',
      ?(timing == null ? null : glucoseTiming(timing)),
    ].join(' · ');
  }

  String glucoseTiming(GlucoseTiming t) => switch (t) {
    GlucoseTiming.fasting => timingFasting,
    GlucoseTiming.afterMeal => timingAfterMeal,
    GlucoseTiming.random => timingRandom,
  };

  String reference(HealthMetric m) => switch (m) {
    HealthMetric.bloodPressure => referencePressure,
    HealthMetric.heartRate => referenceHeartRate,
    HealthMetric.bloodGlucose => referenceGlucose,
    HealthMetric.oxygenSaturation => referenceOxygen,
    HealthMetric.temperature => referenceTemperature,
    HealthMetric.weight => referenceWeight,
    HealthMetric.height => referenceHeight,
    HealthMetric.waist => referenceWaist,
  };

  String status(AssessmentLevel level) => switch (level) {
    AssessmentLevel.inRange => statusInRange,
    AssessmentLevel.outside => statusOutside,
    AssessmentLevel.urgent => statusUrgent,
  };

  /// Null when there is nothing to say.
  String? reasonText(AssessmentReason reason) => switch (reason) {
    AssessmentReason.none => null,
    AssessmentReason.pressureHigh => reasonPressureHigh,
    AssessmentReason.pressureLow => reasonPressureLow,
    AssessmentReason.pressureVeryHigh => reasonPressureVeryHigh,
    AssessmentReason.pulseHigh => reasonPulseHigh,
    AssessmentReason.pulseLow => reasonPulseLow,
    AssessmentReason.glucoseHigh => reasonGlucoseHigh,
    AssessmentReason.glucoseLow => reasonGlucoseLow,
    AssessmentReason.glucoseVeryHigh => reasonGlucoseVeryHigh,
    AssessmentReason.oxygenLow => reasonOxygenLow,
    AssessmentReason.oxygenVeryLow => reasonOxygenVeryLow,
    AssessmentReason.fever => reasonFever,
    AssessmentReason.highFever => reasonHighFever,
    AssessmentReason.temperatureLow => reasonTemperatureLow,
  };

  String bmiCategoryText(BmiCategory c) => switch (c) {
    BmiCategory.under => bmiUnder,
    BmiCategory.normal => bmiNormal,
    BmiCategory.over => bmiOver,
    BmiCategory.obese => bmiObese,
  };

  String errorText(MeasurementError e, HealthMetric m) => switch (e) {
    MeasurementError.outOfRange => healthErrorRange(
      formatHealthNumber(m.min, 0),
      formatHealthNumber(m.max, 0),
    ),
    MeasurementError.secondOutOfRange => healthErrorRange(
      formatHealthNumber(m.secondMin ?? 0, 0),
      formatHealthNumber(m.secondMax ?? 0, 0),
    ),
    MeasurementError.pressureOrder => healthErrorPressureOrder,
    MeasurementError.missingGlucoseTiming => healthErrorTiming,
  };
}

/// "20/10/2026 07:30" in the device's locale format.
String formatMeasuredAt(BuildContext context, DateTime at) {
  final material = MaterialLocalizations.of(context);
  return '${material.formatShortDate(at)} '
      '${material.formatTimeOfDay(TimeOfDay.fromDateTime(at))}';
}
