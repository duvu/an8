import '../../catalog/domain/catalog_models.dart';
import 'session_timeline.dart';

final class PlannedStep {
  const PlannedStep({required this.exercise, required this.duration});

  final Exercise exercise;
  final Duration duration;

  /// Instruction frame to show [offset] into this step; frames share the step evenly.
  ExerciseStep frameAt(Duration offset) {
    final frames = exercise.steps;
    final index =
        offset.inMicroseconds * frames.length ~/ duration.inMicroseconds;
    return frames[index.clamp(0, frames.length - 1)];
  }
}

/// A routine pinned to the catalog version it was started with (PRD §8.4).
final class SessionPlan {
  SessionPlan._(this.routine, this.catalogVersion, this.steps)
    : timeline = SessionTimeline([for (final s in steps) s.duration]);

  factory SessionPlan.from(ContentCatalog catalog, Routine routine) =>
      SessionPlan._(routine, catalog.catalogVersion, [
        for (final step in routine.steps)
          PlannedStep(
            exercise: catalog.exerciseFor(step),
            duration: step.duration,
          ),
      ]);

  final Routine routine;
  final String catalogVersion;
  final List<PlannedStep> steps;
  final SessionTimeline timeline;

  Set<String> get framePaths => {
    for (final step in steps)
      for (final frame in step.exercise.steps) frame.framePath,
  };
}
