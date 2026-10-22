/// Persisted record of one practice session (PRD F05).
enum WorkoutStatus { inProgress, completed, abandoned, interrupted }

final class WorkoutSession {
  const WorkoutSession({
    required this.id,
    required this.routineId,
    required this.routineVersion,
    required this.catalogVersion,
    required this.startedAt,
    required this.activeTime,
    required this.status,
    this.finishedAt,
  });

  final String id;
  final String routineId;
  final int routineVersion;
  final String catalogVersion;
  final DateTime startedAt;
  final DateTime? finishedAt;

  /// Practice time only: no countdown, pause, buffering or skipped time.
  final Duration activeTime;
  final WorkoutStatus status;

  WorkoutSession copyWith({
    DateTime? finishedAt,
    Duration? activeTime,
    WorkoutStatus? status,
  }) => WorkoutSession(
    id: id,
    routineId: routineId,
    routineVersion: routineVersion,
    catalogVersion: catalogVersion,
    startedAt: startedAt,
    finishedAt: finishedAt ?? this.finishedAt,
    activeTime: activeTime ?? this.activeTime,
    status: status ?? this.status,
  );
}

abstract interface class SessionRepository {
  /// Emits after every write, so readers can refresh.
  Stream<void> get changes;

  Future<void> save(WorkoutSession session);
  Future<WorkoutSession?> byId(String id);

  /// Newest first.
  Future<List<WorkoutSession>> all();

  /// Sessions left in progress by an app kill become interrupted. Returns count.
  Future<int> closeUnfinished(DateTime at);
}
