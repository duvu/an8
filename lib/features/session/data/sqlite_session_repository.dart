import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../domain/workout_session.dart';

final class SqliteSessionRepository implements SessionRepository {
  SqliteSessionRepository(this._db);

  static const _table = 'workout_sessions';

  final Database _db;
  final _changes = StreamController<void>.broadcast();

  @override
  Stream<void> get changes => _changes.stream;

  Future<void> dispose() => _changes.close();

  @override
  Future<void> save(WorkoutSession session) async {
    await _db.insert(
      _table,
      _toRow(session),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _notify();
  }

  // A final save may land while the app (provider scope) is shutting down.
  void _notify() {
    if (!_changes.isClosed) _changes.add(null);
  }

  @override
  Future<WorkoutSession?> byId(String id) async {
    final rows = await _db.query(_table, where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : _fromRow(rows.single);
  }

  @override
  Future<List<WorkoutSession>> all() async => (await _db.query(
    _table,
    orderBy: 'started_at DESC',
  )).map(_fromRow).toList();

  @override
  Future<int> closeUnfinished(DateTime at) async {
    final count = await _db.update(
      _table,
      {
        'status': WorkoutStatus.interrupted.name,
        'finished_at': at.toUtc().millisecondsSinceEpoch,
      },
      where: 'status = ?',
      whereArgs: [WorkoutStatus.inProgress.name],
    );
    if (count > 0) _notify();
    return count;
  }

  static Map<String, Object?> _toRow(WorkoutSession s) => {
    'id': s.id,
    'routine_id': s.routineId,
    'routine_version': s.routineVersion,
    'catalog_version': s.catalogVersion,
    'started_at': s.startedAt.toUtc().millisecondsSinceEpoch,
    'finished_at': s.finishedAt?.toUtc().millisecondsSinceEpoch,
    'active_seconds': s.activeTime.inSeconds,
    'status': s.status.name,
  };

  static WorkoutSession _fromRow(Map<String, Object?> row) {
    DateTime time(Object? ms) =>
        DateTime.fromMillisecondsSinceEpoch(ms! as int, isUtc: true).toLocal();
    final finishedAt = row['finished_at'];
    return WorkoutSession(
      id: row['id']! as String,
      routineId: row['routine_id']! as String,
      routineVersion: row['routine_version']! as int,
      catalogVersion: row['catalog_version']! as String,
      startedAt: time(row['started_at']),
      finishedAt: finishedAt == null ? null : time(finishedAt),
      activeTime: Duration(seconds: row['active_seconds']! as int),
      status: WorkoutStatus.values.byName(row['status']! as String),
    );
  }
}
