import 'package:an_nhien/features/health/domain/health_metric.dart';
import 'package:an_nhien/features/health/domain/measurement.dart';
import 'package:an_nhien/features/health/domain/measurement_draft.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 10, 22, 8);

  MeasurementDraft draft({
    HealthMetric metric = HealthMetric.weight,
    String value = '',
    List<String> pressure = const ['', '', ''],
    bool mgDl = false,
    GlucoseTiming? timing,
    DateTime? at,
  }) => MeasurementDraft(
    metric: metric,
    measuredAt: at ?? now,
    valueText: value,
    pressureTexts: pressure,
    inMgDl: mgDl,
    glucoseTiming: timing,
  );

  group('check', () {
    test('accepts a plausible single value (comma decimal)', () {
      expect(draft(value: '65,5').check(now), isNull);
    });

    test('rejects empty and out-of-range values', () {
      expect(
        draft(value: '').check(now),
        isA<InvalidValue>().having(
          (i) => i.error,
          'error',
          MeasurementError.outOfRange,
        ),
      );
      expect(draft(value: '5').check(now), isA<InvalidValue>());
    });

    test('glucose needs a timing and converts mg/dL', () {
      final d = draft(
        metric: HealthMetric.bloodGlucose,
        value: '90',
        mgDl: true,
      );
      expect(
        d.check(now),
        isA<InvalidValue>().having(
          (i) => i.error,
          'error',
          MeasurementError.missingGlucoseTiming,
        ),
      );
      final ok = draft(
        metric: HealthMetric.bloodGlucose,
        value: '90',
        mgDl: true,
        timing: GlucoseTiming.fasting,
      );
      expect(ok.check(now), isNull);
      expect(ok.singleValue, closeTo(5.0, 1e-9));
    });

    test('pressure format, pulse range and future date', () {
      final p = HealthMetric.bloodPressure;
      expect(
        draft(metric: p, pressure: ['128', '', '']).check(now),
        isA<PressureFormat>(),
      );
      expect(
        draft(metric: p, pressure: ['128', '78', '5']).check(now),
        isA<PulseOutOfRange>(),
      );
      expect(
        draft(
          metric: p,
          pressure: ['128', '78', '72'],
          at: now.add(const Duration(hours: 1)),
        ).check(now),
        isA<InTheFuture>(),
      );
    });
  });

  group('toReadings', () {
    test('pressure with pulse is two readings', () {
      final r = draft(
        metric: HealthMetric.bloodPressure,
        pressure: ['128', '78', '72'],
      ).toReadings();
      expect(r.map((e) => e.metric), [
        HealthMetric.bloodPressure,
        HealthMetric.heartRate,
      ]);
      expect(r.first.secondValue, 78);
      expect(r.last.value, 72);
    });

    test('pressure without pulse is one reading', () {
      expect(
        draft(
          metric: HealthMetric.bloodPressure,
          pressure: ['128', '78', ''],
        ).toReadings(),
        hasLength(1),
      );
    });

    test('timing is kept only for glucose', () {
      final w = draft(value: '65', timing: GlucoseTiming.random).toReadings();
      expect(w.single.glucoseTiming, isNull);
    });
  });

  group('pressureInputEffect', () {
    void expectEffect(int box, String text, List<String> fill, int focus) {
      final e = pressureInputEffect(box, text)!;
      expect(e.fill, fill);
      expect(e.focus, focus);
    }

    test('moves on when the number is complete', () {
      expectEffect(0, '128', [], 1);
      expect(pressureInputEffect(0, '12'), isNull);
      expect(pressureInputEffect(2, '72'), isNull);
    });

    test('a pasted line fills the boxes from here onwards', () {
      expectEffect(0, '128/78/72', ['128', '78', '72'], 2);
      expectEffect(1, '78/72/9', ['78', '72'], 2);
    });

    test('a separator key alone moves to the next box', () {
      expectEffect(0, '12/', ['12', ''], 1);
    });
  });
}
