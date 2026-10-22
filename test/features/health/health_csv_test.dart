import 'package:an_nhien/features/health/domain/health_csv.dart';
import 'package:an_nhien/features/health/domain/health_metric.dart';
import 'package:an_nhien/features/health/domain/measurement.dart';
import 'package:flutter_test/flutter_test.dart';

final _labels = CsvLabels(
  header: [
    'Ngày giờ đo',
    'Chỉ số',
    'Giá trị',
    'Giá trị 2',
    'Đơn vị',
    'Lúc',
    'Ghi chú',
  ],
  metricName: (m) => m.name,
  metricUnit: (m) => m == HealthMetric.bloodPressure ? 'mmHg' : 'mmol/L',
  glucoseTiming: (t) => t == GlucoseTiming.fasting ? 'Lúc đói' : t.name,
);

void main() {
  test('BOM, header, one CRLF row per reading, dot decimals', () {
    final csv = buildHealthCsv([
      Measurement(
        id: '1',
        metric: HealthMetric.bloodPressure,
        value: 128,
        secondValue: 78,
        measuredAt: DateTime(2026, 10, 20, 6, 5),
      ),
      Measurement(
        id: '2',
        metric: HealthMetric.bloodGlucose,
        value: 6.2,
        glucoseTiming: GlucoseTiming.fasting,
        measuredAt: DateTime(2026, 10, 20, 6, 30),
      ),
    ], _labels);

    expect(csv.startsWith(csvBom), isTrue);
    expect(csv.substring(1).split('\r\n'), [
      'Ngày giờ đo,Chỉ số,Giá trị,Giá trị 2,Đơn vị,Lúc,Ghi chú',
      '2026-10-20 06:05,bloodPressure,128,78,mmHg,,',
      '2026-10-20 06:30,bloodGlucose,6.2,,mmol/L,Lúc đói,',
      '',
    ]);
  });

  test('notes with commas, quotes and line breaks stay in one cell', () {
    expect(csvField('đau đầu, chóng mặt'), '"đau đầu, chóng mặt"');
    expect(csvField('máy "Omron"'), '"máy ""Omron"""');
    expect(csvField('dòng 1\ndòng 2'), '"dòng 1\ndòng 2"');
    expect(csvField('bình thường'), 'bình thường');
  });

  test('formula-looking notes are kept as text', () {
    expect(csvField('=HYPERLINK("x")'), '"\'=HYPERLINK(""x"")"');
    expect(csvField('+84 912'), "'+84 912");
    expect(csvField('@cmd'), "'@cmd");
    expect(csvField('-5'), '-5'); // a plain number is fine
  });
}
