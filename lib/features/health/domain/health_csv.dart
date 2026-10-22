import 'health_metric.dart';
import 'measurement.dart';

/// Labels the CSV needs; supplied by the UI layer (localised).
final class CsvLabels {
  const CsvLabels({
    required this.header,
    required this.metricName,
    required this.metricUnit,
    required this.glucoseTiming,
  });

  /// Measured at, metric, value, second value, unit, glucose timing, note.
  final List<String> header;
  final String Function(HealthMetric) metricName;
  final String Function(HealthMetric) metricUnit;
  final String Function(GlucoseTiming) glucoseTiming;
}

/// UTF-8 byte-order mark: Excel then reads Vietnamese text correctly.
const csvBom = '﻿';

/// RFC 4180 CSV (comma, CRLF, dot decimals) of [readings] in the given order.
/// Fields that a spreadsheet would run as a formula are neutralised.
String buildHealthCsv(List<Measurement> readings, CsvLabels labels) {
  String two(int n) => n.toString().padLeft(2, '0');
  String time(DateTime t) =>
      '${t.year}-${two(t.month)}-${two(t.day)} ${two(t.hour)}:${two(t.minute)}';
  String number(double? v, int decimals) =>
      v == null ? '' : v.toStringAsFixed(decimals);

  final rows = [
    labels.header,
    for (final r in readings)
      [
        time(r.measuredAt),
        labels.metricName(r.metric),
        number(r.value, r.metric.decimals),
        number(r.secondValue, r.metric.decimals),
        labels.metricUnit(r.metric),
        r.glucoseTiming == null ? '' : labels.glucoseTiming(r.glucoseTiming!),
        r.note ?? '',
      ],
  ];
  return '$csvBom${rows.map((row) => row.map(csvField).join(',')).join('\r\n')}\r\n';
}

/// Quotes when needed; a leading = + - @ (or tab/CR) gets a `'` so the cell
/// stays text (CSV/formula injection).
String csvField(String value) {
  var v = value;
  if (v.isNotEmpty && '=+-@\t\r'.contains(v[0]) && double.tryParse(v) == null) {
    v = "'$v";
  }
  final needsQuotes = v.contains(RegExp('[",\r\n]'));
  return needsQuotes ? '"${v.replaceAll('"', '""')}"' : v;
}
