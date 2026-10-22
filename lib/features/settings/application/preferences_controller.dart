import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/app_database.dart';
import '../data/sqlite_preferences_repository.dart';
import '../domain/preferences.dart';

final preferencesRepositoryProvider = Provider<PreferencesRepository>(
  (ref) => SqlitePreferencesRepository(ref.watch(databaseProvider)),
);

/// Loaded in `main` before the first frame so routing can depend on it.
final initialPreferencesProvider = Provider<Preferences>(
  (ref) =>
      throw UnimplementedError('initialPreferencesProvider must be overridden'),
);

final preferencesProvider =
    NotifierProvider<PreferencesController, Preferences>(
      PreferencesController.new,
    );

class PreferencesController extends Notifier<Preferences> {
  @override
  Preferences build() => ref.read(initialPreferencesProvider);

  Future<void> update(Preferences Function(Preferences) change) async {
    final next = change(state);
    // Persist first: the UI never shows a setting that was not saved.
    await ref.read(preferencesRepositoryProvider).save(next);
    if (ref.mounted) state = next;
  }
}
