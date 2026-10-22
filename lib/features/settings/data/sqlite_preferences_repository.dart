import 'package:sqflite/sqflite.dart';

import '../../catalog/domain/catalog_models.dart';
import '../domain/break_reminder.dart';
import '../domain/preferences.dart';

/// Key-value rows in `preferences`; unknown or corrupt values fall back to defaults.
final class SqlitePreferencesRepository implements PreferencesRepository {
  const SqlitePreferencesRepository(this._db);

  static const _table = 'preferences';

  final Database _db;

  @override
  Future<Preferences> load() async {
    final rows = await _db.query(_table);
    final v = {
      for (final r in rows) r['key']! as String: r['value']! as String,
    };
    const d = Preferences();
    bool flag(String key, bool fallback) =>
        v[key] == null ? fallback : v[key] == 'true';
    return Preferences(
      onboardingCompleted: flag('onboardingCompleted', d.onboardingCompleted),
      position: BodyPosition.values.asNameMap()[v['position']],
      goalTag: v['goalTag'],
      captionsEnabled: flag('captionsEnabled', d.captionsEnabled),
      reducedMotion: flag('reducedMotion', d.reducedMotion),
      soundCues: flag('soundCues', d.soundCues),
      backgroundMusic: flag('backgroundMusic', d.backgroundMusic),
      healthConsent: flag('healthConsent', d.healthConsent),
      reminderEnabled: flag('reminderEnabled', d.reminderEnabled),
      reminderMinutes:
          int.tryParse(v['reminderMinutes'] ?? '') ?? d.reminderMinutes,
      breakReminderEnabled: flag(
        'breakReminderEnabled',
        d.breakReminderEnabled,
      ),
      breakIntervalMinutes:
          int.tryParse(v['breakIntervalMinutes'] ?? '') ??
          d.breakIntervalMinutes,
      breakStartMinutes:
          int.tryParse(v['breakStartMinutes'] ?? '') ?? d.breakStartMinutes,
      breakEndMinutes:
          int.tryParse(v['breakEndMinutes'] ?? '') ?? d.breakEndMinutes,
      breakAlert:
          BreakAlert.values.asNameMap()[v['breakAlert']] ?? d.breakAlert,
    );
  }

  @override
  Future<void> save(Preferences p) => _db.transaction((txn) async {
    final values = <String, String?>{
      'onboardingCompleted': '${p.onboardingCompleted}',
      'position': p.position?.name,
      'goalTag': p.goalTag,
      'captionsEnabled': '${p.captionsEnabled}',
      'reducedMotion': '${p.reducedMotion}',
      'soundCues': '${p.soundCues}',
      'backgroundMusic': '${p.backgroundMusic}',
      'healthConsent': '${p.healthConsent}',
      'reminderEnabled': '${p.reminderEnabled}',
      'reminderMinutes': '${p.reminderMinutes}',
      'breakReminderEnabled': '${p.breakReminderEnabled}',
      'breakIntervalMinutes': '${p.breakIntervalMinutes}',
      'breakStartMinutes': '${p.breakStartMinutes}',
      'breakEndMinutes': '${p.breakEndMinutes}',
      'breakAlert': p.breakAlert.name,
    };
    for (final MapEntry(:key, :value) in values.entries) {
      if (value == null) {
        await txn.delete(_table, where: 'key = ?', whereArgs: [key]);
      } else {
        await txn.insert(_table, {
          'key': key,
          'value': value,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  });
}
