import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'data/local/app_database.dart';
import 'features/session/data/sqlite_session_repository.dart';
import 'features/settings/application/preferences_controller.dart';
import 'features/settings/data/sqlite_preferences_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await AppDatabase.openDefault();
  // A session still in progress means the app was killed mid-practice.
  await SqliteSessionRepository(db).closeUnfinished(DateTime.now());
  final preferences = await SqlitePreferencesRepository(db).load();
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        initialPreferencesProvider.overrideWithValue(preferences),
      ],
      child: const AnNhienApp(),
    ),
  );
}
