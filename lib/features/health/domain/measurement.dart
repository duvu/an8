import 'health_metric.dart';

/// One reading entered by the user. Stored only on this device (D18).
final class Measurement {
  const Measurement({
    required this.id,
    required this.metric,
    required this.value,
    this.secondValue,
    this.glucoseTiming,
    required this.measuredAt,
    this.note,
  });

  final String id;
  final HealthMetric metric;
  final double value;

  /// Diastolic pressure for [HealthMetric.bloodPressure]; null otherwise.
  final double? secondValue;

  /// Only for [HealthMetric.bloodGlucose].
  final GlucoseTiming? glucoseTiming;
  final DateTime measuredAt;
  final String? note;
}

enum MeasurementError {
  outOfRange,
  secondOutOfRange,

  /// Systolic must be above diastolic.
  pressureOrder,
  missingGlucoseTiming,
}

/// Input sanity only (typos, swapped fields); never a medical judgement.
MeasurementError? validateMeasurement(
  HealthMetric metric,
  double value, {
  double? secondValue,
  GlucoseTiming? glucoseTiming,
}) {
  if (value < metric.min || value > metric.max) {
    return MeasurementError.outOfRange;
  }
  if (metric.hasSecondValue) {
    final second = secondValue;
    if (second == null ||
        second < metric.secondMin! ||
        second > metric.secondMax!) {
      return MeasurementError.secondOutOfRange;
    }
    if (value <= second) return MeasurementError.pressureOrder;
  }
  if (metric == HealthMetric.bloodGlucose && glucoseTiming == null) {
    return MeasurementError.missingGlucoseTiming;
  }
  return null;
}

/// Parses what people type on a Vietnamese keyboard: "3,9" or "3.9".
double? parseDecimal(String text) {
  final normalized = text.trim().replaceAll(' ', '').replaceAll(',', '.');
  if (normalized.isEmpty) return null;
  return double.tryParse(normalized);
}

abstract interface class HealthRepository {
  /// Emits after every write, so screens reload.
  Stream<void> get changes;

  /// Newest first.
  Future<List<Measurement>> byMetric(HealthMetric metric);

  /// Every reading, oldest first (export).
  Future<List<Measurement>> all();

  /// Latest reading of each metric that has one.
  Future<Map<HealthMetric, Measurement>> latest();
  Future<void> add(Measurement measurement);
  Future<void> delete(String id);

  /// Retention: the user can erase everything at any time (D18).
  Future<void> deleteAll();
}

/// One line as read off a home blood-pressure monitor:
/// systolic/diastolic[/pulse], e.g. "128/78/72" or "128/78".
typedef PressureReading = ({double systolic, double diastolic, double? pulse});

/// Accepts "/", spaces, "-", "." or "," between the numbers (whatever the
/// phone's number pad offers); null if it is not 2–3 whole numbers.
PressureReading? parsePressureReading(String text) {
  final parts = text.trim().split(RegExp(r'[\s/.,-]+'));
  if (parts.length < 2 || parts.length > 3) return null;
  final numbers = [for (final p in parts) int.tryParse(p)];
  if (numbers.any((n) => n == null)) return null;
  return (
    systolic: numbers[0]!.toDouble(),
    diastolic: numbers[1]!.toDouble(),
    pulse: numbers.length == 3 ? numbers[2]!.toDouble() : null,
  );
}

/// True when one more digit could not give a plausible value, so entry can
/// move on to the next box: "128" (systolic, max 260) or "78" (diastolic,
/// max 160) are done, "12" or "10" may still grow.
bool wholeNumberComplete(String digits, double max) {
  final n = int.tryParse(digits);
  return n != null && n * 10 > max;
}
