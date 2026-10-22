import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Local source of truth for user data. Schema changes are append-only
/// migrations (P06): `migrations[i]` upgrades version i to i + 1.
abstract final class AppDatabase {
  static const fileName = 'an_nhien.db';

  static const migrations = <List<String>>[
    [
      '''
      CREATE TABLE workout_sessions (
        id TEXT PRIMARY KEY,
        routine_id TEXT NOT NULL,
        routine_version INTEGER NOT NULL,
        catalog_version TEXT NOT NULL,
        started_at INTEGER NOT NULL,
        finished_at INTEGER,
        active_seconds INTEGER NOT NULL CHECK (active_seconds >= 0),
        status TEXT NOT NULL
          CHECK (status IN ('inProgress', 'completed', 'abandoned', 'interrupted'))
      )
      ''',
      'CREATE INDEX idx_sessions_started_at ON workout_sessions (started_at)',
      '''
      CREATE TABLE preferences (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
      ''',
    ],
    // v2 — health tracking (D18): manual readings, this device only.
    [
      '''
      CREATE TABLE health_measurements (
        id TEXT PRIMARY KEY,
        metric TEXT NOT NULL CHECK (metric IN ('weight', 'height',
          'bloodPressure', 'heartRate', 'bloodGlucose', 'oxygenSaturation',
          'temperature', 'waist')),
        value REAL NOT NULL,
        second_value REAL,
        glucose_timing TEXT
          CHECK (glucose_timing IN ('fasting', 'afterMeal', 'random')),
        measured_at INTEGER NOT NULL,
        note TEXT
      )
      ''',
      '''
      CREATE INDEX idx_health_metric_time
        ON health_measurements (metric, measured_at)
      ''',
    ],
  ];

  static int get version => migrations.length;

  static Future<Database> open(DatabaseFactory factory, String path) =>
      factory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: version,
          onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
          onCreate: (db, to) => migrate(db, 0, to),
          onUpgrade: migrate,
        ),
      );

  static Future<Database> openDefault() async =>
      open(databaseFactory, p.join(await getDatabasesPath(), fileName));

  /// Runs inside sqflite's open transaction, so a failed step rolls back.
  static Future<void> migrate(Database db, int from, int to) async {
    for (var v = from; v < to; v++) {
      for (final statement in migrations[v]) {
        await db.execute(statement);
      }
    }
  }
}

/// Overridden in `main` with the opened database.
final databaseProvider = Provider<Database>(
  (ref) => throw UnimplementedError('databaseProvider must be overridden'),
);
