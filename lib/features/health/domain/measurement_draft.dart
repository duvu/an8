import 'health_metric.dart';
import 'measurement.dart';

/// Why a draft cannot be saved yet.
sealed class DraftIssue {
  const DraftIssue();
}

/// The value(s) failed [validateMeasurement] for [metric].
final class InvalidValue extends DraftIssue {
  const InvalidValue(this.metric, this.error);

  final HealthMetric metric;
  final MeasurementError error;
}

/// Systolic or diastolic box empty or not whole numbers.
final class PressureFormat extends DraftIssue {
  const PressureFormat();
}

/// The monitor's pulse is outside the heart-rate range.
final class PulseOutOfRange extends DraftIssue {
  const PulseOutOfRange();
}

final class InTheFuture extends DraftIssue {
  const InTheFuture();
}

/// One reading to store.
typedef NewReading = ({
  HealthMetric metric,
  double value,
  double? secondValue,
  GlucoseTiming? glucoseTiming,
});

/// What the user has typed into the add-reading form, as plain data: checks
/// it and says which readings it stands for. Blood pressure is three boxes in
/// monitor order (systolic, diastolic, pulse).
final class MeasurementDraft {
  const MeasurementDraft({
    required this.metric,
    required this.measuredAt,
    this.valueText = '',
    this.pressureTexts = const ['', '', ''],
    this.inMgDl = false,
    this.glucoseTiming,
    this.note = '',
  });

  final HealthMetric metric;
  final DateTime measuredAt;
  final String valueText;
  final List<String> pressureTexts;

  /// Glucose typed in mg/dL instead of the stored mmol/L.
  final bool inMgDl;
  final GlucoseTiming? glucoseTiming;
  final String note;

  /// The boxes as one reading; null without both systolic and diastolic.
  PressureReading? get pressureReading {
    final [systolic, diastolic, pulse] = pressureTexts;
    if (systolic.isEmpty || diastolic.isEmpty) return null;
    return parsePressureReading(
      [systolic, diastolic, if (pulse.isNotEmpty) pulse].join('/'),
    );
  }

  /// Entered value in the stored unit (glucose mg/dL → mmol/L).
  double? get singleValue {
    final value = parseDecimal(valueText);
    if (value == null) return null;
    return metric == HealthMetric.bloodGlucose && inMgDl
        ? value / mgDlPerMmolL
        : value;
  }

  /// Typos only; says nothing medical. Null when the draft can be saved.
  DraftIssue? check(DateTime now) {
    if (metric == HealthMetric.bloodPressure) {
      final r = pressureReading;
      if (r == null) return const PressureFormat();
      final error = validateMeasurement(
        metric,
        r.systolic,
        secondValue: r.diastolic,
      );
      if (error != null) return InvalidValue(metric, error);
      final pulse = r.pulse;
      if (pulse != null &&
          validateMeasurement(HealthMetric.heartRate, pulse) != null) {
        return const PulseOutOfRange();
      }
    } else {
      final value = singleValue;
      final error = value == null
          ? MeasurementError.outOfRange
          : validateMeasurement(metric, value, glucoseTiming: glucoseTiming);
      if (error != null) return InvalidValue(metric, error);
    }
    return measuredAt.isAfter(now) ? const InTheFuture() : null;
  }

  /// The readings to store; call only when [check] is null. The monitor's
  /// pulse is also a heart-rate reading (same moment).
  List<NewReading> toReadings() {
    if (metric == HealthMetric.bloodPressure) {
      final r = pressureReading!;
      return [
        (
          metric: metric,
          value: r.systolic,
          secondValue: r.diastolic,
          glucoseTiming: null,
        ),
        if (r.pulse case final pulse?)
          (
            metric: HealthMetric.heartRate,
            value: pulse,
            secondValue: null,
            glucoseTiming: null,
          ),
      ];
    }
    return [
      (
        metric: metric,
        value: singleValue!,
        secondValue: null,
        glucoseTiming: metric == HealthMetric.bloodGlucose
            ? glucoseTiming
            : null,
      ),
    ];
  }
}

/// Largest plausible value per pressure box, for auto-advance.
final pressureBoxMax = [
  HealthMetric.bloodPressure.max,
  HealthMetric.bloodPressure.secondMax!,
  HealthMetric.heartRate.max,
];

/// What typing [text] into pressure box [box] should do: move on once a
/// number is complete ("128", "78"), or — when a separator key ("/", space,
/// "-", ".", ",") or a pasted "128/78/72" gives several numbers — fill the
/// boxes from [box] onwards. Null when nothing should change.
({List<String> fill, int focus})? pressureInputEffect(int box, String text) {
  final last = pressureBoxMax.length - 1;
  final parts = text.split(RegExp('[^0-9]+'));
  if (parts.length > 1) {
    final end = (box + parts.length - 1).clamp(0, last);
    return (fill: parts.sublist(0, end - box + 1), focus: end);
  }
  if (box < last && wholeNumberComplete(text, pressureBoxMax[box])) {
    return (fill: const [], focus: box + 1);
  }
  return null;
}
