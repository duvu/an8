import 'health_metric.dart';
import 'measurement.dart';

/// Where a reading sits against commonly used reference values. Wording in
/// the UI is "outside the reference range — talk to your doctor", never a
/// diagnosis (PRD §3, §9). Thresholds are listed in DECISIONS.md D18 with
/// their sources and still need clinician review (T11).
enum AssessmentLevel { inRange, outside, urgent }

enum AssessmentReason {
  none,
  pressureHigh,
  pressureLow,
  pressureVeryHigh,
  pulseHigh,
  pulseLow,
  glucoseHigh,
  glucoseLow,
  glucoseVeryHigh,
  oxygenLow,
  oxygenVeryLow,
  fever,
  highFever,
  temperatureLow,
}

final class Assessment {
  const Assessment(this.level, this.reason);

  static const ok = Assessment(AssessmentLevel.inRange, AssessmentReason.none);

  final AssessmentLevel level;
  final AssessmentReason reason;
}

/// Home blood pressure: ESC/ESH 2018 & VNHA 2018 use >= 135/85 for home
/// readings; >= 180/120 is a hypertensive crisis level (AHA).
/// Resting pulse: 60–100/min. Glucose (ADA 2024): fasting < 7.0, other
/// < 11.1 mmol/L; < 3.9 is low; >= 16.7 very high. SpO2 (NHS pulse-oximetry
/// guidance): < 95 % low, <= 92 % urgent. Temperature: >= 37.5 °C fever,
/// >= 39.5 °C high fever, < 35.5 °C low.
Assessment assess(Measurement m) =>
    _assessors[m.metric]?.call(m) ?? Assessment.ok;

Assessment _outside(AssessmentReason r) =>
    Assessment(AssessmentLevel.outside, r);

Assessment _urgent(AssessmentReason r) => Assessment(AssessmentLevel.urgent, r);

Assessment _pressure(Measurement m) {
  final v = m.value;
  final d = m.secondValue!;
  if (v >= 180 || d >= 120) return _urgent(AssessmentReason.pressureVeryHigh);
  if (v >= 135 || d >= 85) return _outside(AssessmentReason.pressureHigh);
  if (v < 90 || d < 60) return _outside(AssessmentReason.pressureLow);
  return Assessment.ok;
}

Assessment _heartRate(Measurement m) {
  if (m.value > 100) return _outside(AssessmentReason.pulseHigh);
  if (m.value < 60) return _outside(AssessmentReason.pulseLow);
  return Assessment.ok;
}

Assessment _glucose(Measurement m) {
  final v = m.value;
  if (v < 3.9) return _urgent(AssessmentReason.glucoseLow);
  if (v >= 16.7) return _urgent(AssessmentReason.glucoseVeryHigh);
  final limit = m.glucoseTiming == GlucoseTiming.fasting ? 7.0 : 11.1;
  if (v >= limit) return _outside(AssessmentReason.glucoseHigh);
  return Assessment.ok;
}

Assessment _oxygen(Measurement m) {
  if (m.value <= 92) return _urgent(AssessmentReason.oxygenVeryLow);
  if (m.value < 95) return _outside(AssessmentReason.oxygenLow);
  return Assessment.ok;
}

Assessment _temperature(Measurement m) {
  final v = m.value;
  if (v >= 39.5) return _urgent(AssessmentReason.highFever);
  if (v >= 37.5) return _outside(AssessmentReason.fever);
  if (v < 35.5) return _outside(AssessmentReason.temperatureLow);
  return Assessment.ok;
}

/// One rule per metric that has a reference range (see
/// [HealthMetric.hasReferenceRange]); a new metric adds an entry here instead
/// of editing [assess]. Metrics without a range are only tracked over time.
final _assessors = <HealthMetric, Assessment Function(Measurement)>{
  HealthMetric.bloodPressure: _pressure,
  HealthMetric.heartRate: _heartRate,
  HealthMetric.bloodGlucose: _glucose,
  HealthMetric.oxygenSaturation: _oxygen,
  HealthMetric.temperature: _temperature,
};

/// Metrics that [assess] has a rule for; kept in step with
/// [HealthMetric.hasReferenceRange] by a test.
Set<HealthMetric> get assessedMetrics => _assessors.keys.toSet();

/// BMI categories for Asian adults (WHO expert consultation 2004, used by
/// the Vietnamese Ministry of Health): < 18.5, 18.5–22.9, 23–24.9, >= 25.
enum BmiCategory { under, normal, over, obese }

const _normalBmiMin = 18.5;
const _normalBmiEnd = 23.0; // exclusive

double _squareMetres(double heightCm) {
  final m = heightCm / 100;
  return m * m;
}

double bmi({required double weightKg, required double heightCm}) =>
    weightKg / _squareMetres(heightCm);

BmiCategory bmiCategory(double value) => switch (value) {
  < _normalBmiMin => BmiCategory.under,
  < _normalBmiEnd => BmiCategory.normal,
  < 25 => BmiCategory.over,
  _ => BmiCategory.obese,
};

/// Weights (kg, 0.1 kg steps) whose BMI is in the normal range for
/// [heightCm]. Rounded inwards so every weight shown is really "normal":
/// 160 cm → 47.4–58.8 kg. Adult height barely changes, so the latest height
/// gives a lasting target.
typedef WeightRange = ({double min, double max});

WeightRange normalWeightRange(double heightCm) {
  final sq = _squareMetres(heightCm);
  return (
    min: _tenthsUp(_normalBmiMin * sq),
    // The upper BMI bound is exclusive: step just below it.
    max: ((_normalBmiEnd * sq * 10) - 1e-9).floorToDouble() / 10,
  );
}

/// Kg from [weightKg] to the nearest edge of [normalWeightRange], rounded up
/// to 0.1 kg: positive = above the range, negative = below, 0 = inside.
/// Agrees with [bmiCategory] (the same cut-offs decide "inside").
double weightOutsideNormal({
  required double weightKg,
  required double heightCm,
}) {
  final range = normalWeightRange(heightCm);
  return switch (bmiCategory(bmi(weightKg: weightKg, heightCm: heightCm))) {
    BmiCategory.normal => 0,
    BmiCategory.under => -_tenthsUp(range.min - weightKg),
    BmiCategory.over || BmiCategory.obese => _tenthsUp(weightKg - range.max),
  };
}

/// Rounds up to 0.1, tolerating binary noise (58.8 - 58.7 is not 0.1).
double _tenthsUp(double value) => ((value * 10) - 1e-6).ceilToDouble() / 10;

/// Unintended loss of >= 5 % body weight in 6 months is a common geriatric
/// warning sign (e.g. GLIM criteria). [readings] in any order.
const weightLossWindow = Duration(days: 182);
const weightLossThreshold = 0.05;

/// Fractional change from the earliest reading inside [weightLossWindow]
/// before the latest one, to the latest; null with fewer than 2 readings.
double? recentWeightChange(List<Measurement> readings) {
  if (readings.length < 2) return null;
  final sorted = [...readings]
    ..sort((a, b) => a.measuredAt.compareTo(b.measuredAt));
  final latest = sorted.last;
  final from = latest.measuredAt.subtract(weightLossWindow);
  final first = sorted.firstWhere((m) => !m.measuredAt.isBefore(from));
  if (identical(first, latest)) return null;
  return (latest.value - first.value) / first.value;
}

bool significantWeightLoss(List<Measurement> readings) {
  final change = recentWeightChange(readings);
  return change != null && change <= -weightLossThreshold;
}
