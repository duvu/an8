import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../domain/health_metric.dart';
import '../domain/measurement.dart';

final class SqliteHealthRepository implements HealthRepository {
  SqliteHealthRepository(this._db);

  static const _table = 'health_measurements';

  final Database _db;
  final _changes = StreamController<void>.broadcast();

  @override
  Stream<void> get changes => _changes.stream;

  Future<void> dispose() => _changes.close();

  void _notify() {
    if (!_changes.isClosed) _changes.add(null);
  }

  @override
  Future<List<Measurement>> byMetric(HealthMetric metric) async =>
      (await _db.query(
        _table,
        where: 'metric = ?',
        whereArgs: [metric.name],
        orderBy: 'measured_at DESC',
      )).map(_fromRow).toList();

  @override
  Future<List<Measurement>> all() async => (await _db.query(
    _table,
    orderBy: 'measured_at ASC',
  )).map(_fromRow).toList();

  @override
  Future<Map<HealthMetric, Measurement>> latest() async {
    // One row per metric: the one with the greatest measured_at.
    final rows = await _db.rawQuery('''
      SELECT m.* FROM $_table m
      JOIN (SELECT metric, MAX(measured_at) AS at FROM $_table GROUP BY metric) l
        ON m.metric = l.metric AND m.measured_at = l.at
      ''');
    return {for (final m in rows.map(_fromRow)) m.metric: m};
  }

  @override
  Future<void> add(Measurement m) async {
    await _db.insert(_table, {
      'id': m.id,
      'metric': m.metric.name,
      'value': m.value,
      'second_value': m.secondValue,
      'glucose_timing': m.glucoseTiming?.name,
      'measured_at': m.measuredAt.toUtc().millisecondsSinceEpoch,
      'note': m.note,
    });
    _notify();
  }

  @override
  Future<void> delete(String id) async {
    await _db.delete(_table, where: 'id = ?', whereArgs: [id]);
    _notify();
  }

  @override
  Future<void> deleteAll() async {
    await _db.delete(_table);
    _notify();
  }

  static Measurement _fromRow(Map<String, Object?> r) => Measurement(
    id: r['id']! as String,
    metric: HealthMetric.values.byName(r['metric']! as String),
    value: (r['value']! as num).toDouble(),
    secondValue: (r['second_value'] as num?)?.toDouble(),
    glucoseTiming: switch (r['glucose_timing']) {
      final String name => GlucoseTiming.values.byName(name),
      _ => null,
    },
    measuredAt: DateTime.fromMillisecondsSinceEpoch(
      r['measured_at']! as int,
      isUtc: true,
    ).toLocal(),
    note: r['note'] as String?,
  );
}
