import '../../../core/clock/app_clock.dart';
import '../../../core/id/id_generator.dart';
import '../domain/session_machine.dart';
import '../domain/session_plan.dart';
import '../domain/workout_session.dart';

/// Keeps the stored record of one session in step with its progress. Only an
/// `inProgress` record is ever updated, so an outcome is written once (P04).
final class SessionRecorder {
  SessionRecorder(this._repository, this._clock, this._ids);

  final SessionRepository _repository;
  final AppClock _clock;
  final IdGenerator _ids;
  WorkoutSession? _record;

  /// Set once [begin] has created the record.
  String? get sessionId => _record?.id;

  Future<void> begin(SessionPlan plan) async {
    final record = WorkoutSession(
      id: _ids.next(),
      routineId: plan.routine.id,
      routineVersion: plan.routine.version,
      catalogVersion: plan.catalogVersion,
      startedAt: _clock.now(),
      activeTime: Duration.zero,
      status: WorkoutStatus.inProgress,
    );
    _record = record;
    await _repository.save(record);
  }

  Future<void> saveProgress(Duration activeTime) async {
    final record = _record;
    if (record == null || record.status != WorkoutStatus.inProgress) return;
    final updated = record.copyWith(activeTime: activeTime);
    _record = updated;
    await _repository.save(updated);
  }

  Future<void> finish(SessionOutcome outcome, Duration activeTime) async {
    final record = _record;
    if (record == null || record.status != WorkoutStatus.inProgress) return;
    final done = record.copyWith(
      finishedAt: _clock.now(),
      activeTime: activeTime,
      status: switch (outcome) {
        SessionOutcome.completed => WorkoutStatus.completed,
        SessionOutcome.abandoned => WorkoutStatus.abandoned,
        SessionOutcome.interrupted => WorkoutStatus.interrupted,
      },
    );
    _record = done;
    await _repository.save(done);
  }
}
