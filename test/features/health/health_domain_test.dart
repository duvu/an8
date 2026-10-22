import 'package:an_nhien/features/health/domain/health_assessment.dart';
import 'package:an_nhien/features/health/domain/health_metric.dart';
import 'package:an_nhien/features/health/domain/measurement.dart';
import 'package:flutter_test/flutter_test.dart';

Measurement _m(
  HealthMetric metric,
  double value, {
  double? second,
  GlucoseTiming? timing,
  DateTime? at,
}) => Measurement(
  id: '$value',
  metric: metric,
  value: value,
  secondValue: second,
  glucoseTiming: timing,
  measuredAt: at ?? DateTime(2026, 10, 20),
);

Assessment _bp(double s, double d) =>
    assess(_m(HealthMetric.bloodPressure, s, second: d));

void main() {
  test('every metric with a reference range has an assessment rule', () {
    final withRange = {
      for (final m in HealthMetric.values)
        if (m.hasReferenceRange) m,
    };
    expect(assessedMetrics, withRange);
  });

  group('parseDecimal', () {
    test('accepts comma and dot', () {
      expect(parseDecimal('3,9'), 3.9);
      expect(parseDecimal(' 62.5 '), 62.5);
      expect(parseDecimal('120'), 120);
    });
    test('rejects empty or garbage', () {
      expect(parseDecimal(''), isNull);
      expect(parseDecimal('abc'), isNull);
    });
  });

  group('parsePressureReading', () {
    test('reads systolic/diastolic/pulse as on the monitor', () {
      final r = parsePressureReading('128/78/72')!;
      expect((r.systolic, r.diastolic, r.pulse), (128.0, 78.0, 72.0));
    });
    test('pulse is optional; spaces and dashes also separate', () {
      expect(parsePressureReading('128/78')!.pulse, isNull);
      expect(parsePressureReading('128 78 72')!.pulse, 72);
      expect(parsePressureReading(' 128 - 78 ')!.diastolic, 78);
      expect(parsePressureReading('128.78,72')!.pulse, 72);
    });
    test('anything else is rejected', () {
      for (final text in ['', '128', '128/78/72/1', '12a/78']) {
        expect(parsePressureReading(text), isNull, reason: text);
      }
    });
  });

  group('wholeNumberComplete', () {
    test('done when one more digit would be implausible', () {
      expect(wholeNumberComplete('128', 260), isTrue);
      expect(wholeNumberComplete('95', 260), isTrue);
      expect(wholeNumberComplete('78', 160), isTrue);
    });
    test('waits while the number may still grow', () {
      for (final (digits, max) in [
        ('12', 260.0),
        ('26', 260.0),
        ('10', 160.0),
        ('9', 160.0),
        ('', 260.0),
      ]) {
        expect(wholeNumberComplete(digits, max), isFalse, reason: digits);
      }
    });
  });

  group('validateMeasurement', () {
    test('plausible values pass', () {
      expect(validateMeasurement(HealthMetric.weight, 58.4), isNull);
      expect(
        validateMeasurement(HealthMetric.bloodPressure, 128, secondValue: 82),
        isNull,
      );
    });
    test('typos are caught', () {
      expect(
        validateMeasurement(HealthMetric.weight, 584),
        MeasurementError.outOfRange,
      );
      expect(
        validateMeasurement(HealthMetric.bloodPressure, 128),
        MeasurementError.secondOutOfRange,
      );
      expect(
        validateMeasurement(HealthMetric.bloodPressure, 80, secondValue: 120),
        MeasurementError.pressureOrder,
      );
    });
    test('glucose needs its timing', () {
      expect(
        validateMeasurement(HealthMetric.bloodGlucose, 6),
        MeasurementError.missingGlucoseTiming,
      );
      expect(
        validateMeasurement(
          HealthMetric.bloodGlucose,
          6,
          glucoseTiming: GlucoseTiming.fasting,
        ),
        isNull,
      );
    });
  });

  group('assess', () {
    test('blood pressure bands (home readings)', () {
      expect(_bp(128, 82).level, AssessmentLevel.inRange);
      expect(_bp(135, 80).reason, AssessmentReason.pressureHigh);
      expect(_bp(130, 85).reason, AssessmentReason.pressureHigh);
      expect(_bp(85, 55).reason, AssessmentReason.pressureLow);
      expect(_bp(180, 100).level, AssessmentLevel.urgent);
      expect(_bp(160, 120).level, AssessmentLevel.urgent);
    });

    test('glucose depends on timing; lows are urgent', () {
      Assessment g(double v, GlucoseTiming t) =>
          assess(_m(HealthMetric.bloodGlucose, v, timing: t));
      expect(g(6.9, GlucoseTiming.fasting).level, AssessmentLevel.inRange);
      expect(
        g(7.0, GlucoseTiming.fasting).reason,
        AssessmentReason.glucoseHigh,
      );
      expect(g(10, GlucoseTiming.afterMeal).level, AssessmentLevel.inRange);
      expect(
        g(11.1, GlucoseTiming.random).reason,
        AssessmentReason.glucoseHigh,
      );
      expect(g(3.8, GlucoseTiming.random).level, AssessmentLevel.urgent);
      expect(g(16.7, GlucoseTiming.random).level, AssessmentLevel.urgent);
    });

    test('pulse, oxygen and temperature', () {
      expect(
        assess(_m(HealthMetric.heartRate, 72)).level,
        AssessmentLevel.inRange,
      );
      expect(
        assess(_m(HealthMetric.heartRate, 104)).reason,
        AssessmentReason.pulseHigh,
      );
      expect(
        assess(_m(HealthMetric.heartRate, 55)).reason,
        AssessmentReason.pulseLow,
      );
      expect(
        assess(_m(HealthMetric.oxygenSaturation, 94)).level,
        AssessmentLevel.outside,
      );
      expect(
        assess(_m(HealthMetric.oxygenSaturation, 92)).level,
        AssessmentLevel.urgent,
      );
      expect(
        assess(_m(HealthMetric.temperature, 37.5)).reason,
        AssessmentReason.fever,
      );
      expect(
        assess(_m(HealthMetric.temperature, 39.5)).level,
        AssessmentLevel.urgent,
      );
    });

    test('weight, height and waist are tracked without judgement', () {
      for (final metric in [
        HealthMetric.weight,
        HealthMetric.height,
        HealthMetric.waist,
      ]) {
        expect(assess(_m(metric, 100)).level, AssessmentLevel.inRange);
      }
    });
  });

  group('BMI', () {
    test('value and Asian cut-offs', () {
      expect(bmi(weightKg: 60, heightCm: 160), closeTo(23.44, 0.01));
      expect(bmiCategory(18.4), BmiCategory.under);
      expect(bmiCategory(18.5), BmiCategory.normal);
      expect(bmiCategory(22.9), BmiCategory.normal);
      expect(bmiCategory(23), BmiCategory.over);
      expect(bmiCategory(25), BmiCategory.obese);
    });
    test('normal weight range is rounded inwards to 0.1 kg', () {
      final r = normalWeightRange(160); // exact 47.36–58.88
      expect((r.min, r.max), (47.4, 58.8));
      expect(
        bmiCategory(bmi(weightKg: r.min, heightCm: 160)),
        BmiCategory.normal,
      );
      expect(
        bmiCategory(bmi(weightKg: r.max, heightCm: 160)),
        BmiCategory.normal,
      );
    });
    test('distance outside the range agrees with the BMI category', () {
      double out(double w) => weightOutsideNormal(weightKg: w, heightCm: 160);
      expect(out(55), 0);
      expect(out(58.8), 0);
      expect(out(58.9), 0.1); // BMI 23.0 → over
      expect(out(60), 1.2);
      expect(out(47.4), 0);
      expect(out(47.3), -0.1);
      expect(out(45), -2.4);
    });
  });

  group('weight loss', () {
    Measurement w(double kg, DateTime at) =>
        _m(HealthMetric.weight, kg, at: at);

    test('5 % in six months is flagged', () {
      final readings = [
        w(60, DateTime(2026, 6, 1)),
        w(58, DateTime(2026, 8, 1)),
        w(56.9, DateTime(2026, 10, 1)),
      ];
      expect(recentWeightChange(readings), closeTo(-0.0517, 0.001));
      expect(significantWeightLoss(readings), isTrue);
    });

    test('older readings outside the window do not count', () {
      final readings = [
        w(70, DateTime(2025, 1, 1)),
        w(60, DateTime(2026, 9, 1)),
        w(59, DateTime(2026, 10, 1)),
      ];
      expect(significantWeightLoss(readings), isFalse);
    });

    test('one reading has no trend', () {
      expect(recentWeightChange([w(60, DateTime(2026))]), isNull);
    });
  });
}
