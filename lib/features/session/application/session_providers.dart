import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/app_database.dart';
import '../data/sqlite_session_repository.dart';
import '../domain/workout_session.dart';

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  final repository = SqliteSessionRepository(ref.watch(databaseProvider));
  ref.onDispose(repository.dispose);
  return repository;
});

final sessionByIdProvider = FutureProvider.autoDispose
    .family<WorkoutSession?, String>(
      (ref, id) => ref.watch(sessionRepositoryProvider).byId(id),
    );

/// All recorded sessions, newest first; refreshes on every repository write.
final sessionsProvider = FutureProvider<List<WorkoutSession>>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  final subscription = repository.changes.listen((_) => ref.invalidateSelf());
  ref.onDispose(subscription.cancel);
  return repository.all();
});
