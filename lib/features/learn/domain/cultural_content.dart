/// Editorial history/culture content (D17). Never movement instruction, never
/// a medical claim, never unlocks an exercise.
final class ExerciseStory {
  const ExerciseStory({
    required this.exerciseId,
    required this.title,
    required this.angle,
    required this.meaning,
    required this.movementAwareness,
    required this.historicalNote,
    required this.sourceIds,
  });

  final String exerciseId;
  final String title;

  /// How to read it, e.g. "Biểu tượng/đọc hiểu văn hóa".
  final String angle;
  final String meaning;
  final String movementAwareness;

  /// Null when the pack only points to the system profile.
  final String? historicalNote;
  final List<String> sourceIds;
}

final class SystemProfile {
  const SystemProfile({
    required this.id,
    required this.originLabel,
    required this.history,
    required this.culturalContext,
    required this.interpretiveFrame,
    required this.cautions,
    required this.sourceIds,
  });

  /// Eastern system slug (e.g. `baduanjin`) or `basics`.
  final String id;
  final String originLabel;
  final String history;
  final String culturalContext;
  final String interpretiveFrame;
  final List<String> cautions;
  final List<String> sourceIds;
}

/// A short read-aloud topic; shown as text until a recording is approved.
final class StoryEpisode {
  const StoryEpisode({
    required this.id,
    required this.title,
    required this.scriptPath,
  });

  final String id;
  final String title;

  /// Path inside the cultural content package.
  final String scriptPath;
}

final class Reference {
  const Reference({required this.id, required this.title, required this.url});

  final String id;
  final String title;
  final String url;
}

final class CulturalContent {
  CulturalContent({
    required List<ExerciseStory> stories,
    required List<SystemProfile> profiles,
    required this.episodes,
    required List<Reference> references,
  }) : _stories = {for (final s in stories) s.exerciseId: s},
       _profiles = {for (final p in profiles) p.id: p},
       _references = {for (final r in references) r.id: r};

  final Map<String, ExerciseStory> _stories;
  final Map<String, SystemProfile> _profiles;
  final Map<String, Reference> _references;
  final List<StoryEpisode> episodes;

  ExerciseStory? storyFor(String exerciseId) => _stories[exerciseId];
  SystemProfile? profileFor(String systemId) => _profiles[systemId];

  /// Known references only; unknown ids are skipped.
  List<Reference> referencesFor(List<String> ids) => [
    for (final id in ids) ?_references[id],
  ];
}
