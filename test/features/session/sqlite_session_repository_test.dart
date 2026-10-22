import 'package:an_nhien/features/session/data/sqlite_session_repository.dart';
import 'package:an_nhien/features/session/domain/workout_session.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';

WorkoutSession session(String id, DateTime startedAt, WorkoutStatus status) =>
    WorkoutSession(
      id: id,
      routineId: 'R01',
      routineVersion: 1,
      catalogVersion: '2026.10.18.3',
      startedAt: startedAt,
      activeTime: const Duration(seconds: 125),
      status: status,
    );

void main() {
  late SqliteSessionRepository repo;

  setUp(() async {
    final db = await openTestDatabase();
    addTearDown(db.close);
    repo = SqliteSessionRepository(db);
  });

  test('round-trips a session and upserts by id', () async {
    final start = DateTime(2026, 10, 18, 7);
    await repo.save(session('a', start, WorkoutStatus.inProgress));
    await repo.save(
      session('a', start, WorkoutStatus.inProgress).copyWith(
        status: WorkoutStatus.completed,
        finishedAt: start.add(const Duration(minutes: 7)),
      ),
    );

    final loaded = (await repo.byId('a'))!;
    expect(loaded.status, WorkoutStatus.completed);
    expect(loaded.startedAt, start);
    expect(loaded.finishedAt, start.add(const Duration(minutes: 7)));
    expect(loaded.activeTime, const Duration(seconds: 125));
    expect(loaded.catalogVersion, '2026.10.18.3');
    expect(await repo.all(), hasLength(1));
    expect(await repo.byId('missing'), isNull);
  });

  test('lists newest first', () async {
    await repo.save(
      session('old', DateTime(2026, 10, 1), WorkoutStatus.completed),
    );
    await repo.save(
      session('new', DateTime(2026, 10, 2), WorkoutStatus.abandoned),
    );
    expect((await repo.all()).map((s) => s.id), ['new', 'old']);
  });

  test(
    'closes sessions left in progress by an app kill as interrupted',
    () async {
      await repo.save(
        session('a', DateTime(2026, 10, 1), WorkoutStatus.inProgress),
      );
      await repo.save(
        session('b', DateTime(2026, 10, 1), WorkoutStatus.completed),
      );

      expect(await repo.closeUnfinished(DateTime(2026, 10, 2)), 1);
      expect((await repo.byId('a'))!.status, WorkoutStatus.interrupted);
      expect((await repo.byId('b'))!.status, WorkoutStatus.completed);
    },
  );
}
