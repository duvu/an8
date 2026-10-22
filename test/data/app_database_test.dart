import 'package:an_nhien/data/local/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../support/fakes.dart';

void main() {
  test('creates schema at the latest version', () async {
    final db = await openTestDatabase();
    addTearDown(db.close);

    expect(await db.getVersion(), AppDatabase.version);
    final tables = await db.query(
      'sqlite_master',
      columns: ['name'],
      where: "type = 'table'",
    );
    expect(
      tables.map((t) => t['name']),
      containsAll(['workout_sessions', 'preferences', 'health_measurements']),
    );
  });

  test('each migration step applies on top of the previous ones', () async {
    sqfliteFfiInit();
    final db = await databaseFactoryFfiNoIsolate.openDatabase(
      inMemoryDatabasePath,
    );
    addTearDown(db.close);
    for (var v = 0; v < AppDatabase.version; v++) {
      await AppDatabase.migrate(db, v, v + 1);
    }
  });

  test('rejects invalid session status', () async {
    final db = await openTestDatabase();
    addTearDown(db.close);

    expect(
      () => db.insert('workout_sessions', {
        'id': 'x',
        'routine_id': 'R01',
        'routine_version': 1,
        'catalog_version': 'v',
        'started_at': 0,
        'active_seconds': 0,
        'status': 'done',
      }),
      throwsA(isA<DatabaseException>()),
    );
  });

  test('v1 → v2 keeps existing sessions and adds health readings', () async {
    sqfliteFfiInit();
    final db = await databaseFactoryFfiNoIsolate.openDatabase(
      inMemoryDatabasePath,
    );
    addTearDown(db.close);
    await AppDatabase.migrate(db, 0, 1);
    await db.insert('workout_sessions', {
      'id': 's1',
      'routine_id': 'R01',
      'routine_version': 1,
      'catalog_version': 'v',
      'started_at': 0,
      'active_seconds': 60,
      'status': 'completed',
    });
    await AppDatabase.migrate(db, 1, 2);

    expect(await db.query('workout_sessions'), hasLength(1));
    expect(await db.query('health_measurements'), isEmpty);
  });

  test('rejects an unknown health metric', () async {
    final db = await openTestDatabase();
    addTearDown(db.close);
    expect(
      () => db.insert('health_measurements', {
        'id': 'x',
        'metric': 'mood',
        'value': 1,
        'measured_at': 0,
      }),
      throwsA(isA<DatabaseException>()),
    );
  });
}
