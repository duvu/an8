/// What the user can log by hand (D18). No device sync (PRD §2.2).
enum HealthMetric {
  weight(min: 20, max: 300, decimals: 1),
  height(min: 100, max: 230, decimals: 0),

  /// Systolic in `value`, diastolic in `secondValue` (mmHg).
  bloodPressure(min: 60, max: 260, decimals: 0, secondMin: 30, secondMax: 160),

  /// Resting pulse, beats per minute.
  heartRate(min: 30, max: 220, decimals: 0),

  /// Stored in mmol/L; mg/dL input is converted ([mgDlPerMmolL]).
  bloodGlucose(min: 1, max: 35, decimals: 1),
  oxygenSaturation(min: 50, max: 100, decimals: 0),
  temperature(min: 34, max: 43, decimals: 1),
  waist(min: 40, max: 200, decimals: 0);

  const HealthMetric({
    required this.min,
    required this.max,
    required this.decimals,
    this.secondMin,
    this.secondMax,
  });

  /// Plausible input range: guards against typos, says nothing medical.
  final double min;
  final double max;
  final int decimals;
  final double? secondMin;
  final double? secondMax;

  bool get hasSecondValue => secondMin != null;

  /// Has a reference range in `assess`; weight, height and waist are only
  /// tracked over time.
  bool get hasReferenceRange => switch (this) {
    weight || height || waist => false,
    _ => true,
  };
}

/// When a glucose reading was taken; the reference range depends on it.
enum GlucoseTiming { fasting, afterMeal, random }

const mgDlPerMmolL = 18.0;
