/// Immutable content domain (schema v1). Pure Dart: no Flutter imports (P08).
library;

enum ReviewStatus { draft, inReview, approved, retired }

enum BodyPosition { seated, standing, mixed }

enum Intensity { gentle, easy, moderate }

enum MediaKind { storyboard, video, rive, audio, poster }

enum MediaVariant { storyboard, video, rive }

final class ExerciseStep {
  const ExerciseStep({
    required this.order,
    required this.instruction,
    required this.framePath,
  });

  final int order;
  final String instruction;
  final String framePath;
}

final class Exercise {
  const Exercise({
    required this.id,
    required this.version,
    required this.locale,
    required this.title,
    required this.defaultDuration,
    required this.position,
    required this.intensity,
    required this.tags,
    required this.reviewStatus,
    required this.demoOnly,
    required this.safetyNotes,
    required this.steps,
    required this.posterMediaId,
    required this.mediaAssetIds,
  });

  final String id;
  final int version;
  final String locale;
  final String title;
  final Duration defaultDuration;
  final BodyPosition position;
  final Intensity intensity;
  final List<String> tags;
  final ReviewStatus reviewStatus;
  final bool demoOnly;
  final List<String> safetyNotes;
  final List<ExerciseStep> steps;
  final String posterMediaId;
  final List<String> mediaAssetIds;
}

final class RoutineStep {
  const RoutineStep({
    required this.order,
    required this.exerciseId,
    required this.exerciseVersion,
    required this.duration,
    required this.mediaVariant,
  });

  final int order;
  final String exerciseId;
  final int exerciseVersion;
  final Duration duration;
  final MediaVariant mediaVariant;
}

final class Routine {
  const Routine({
    required this.id,
    required this.version,
    required this.locale,
    required this.title,
    required this.description,
    required this.tags,
    required this.reviewStatus,
    required this.demoOnly,
    required this.steps,
  });

  final String id;
  final int version;
  final String locale;
  final String title;
  final String description;
  final List<String> tags;
  final ReviewStatus reviewStatus;
  final bool demoOnly;
  final List<RoutineStep> steps;

  Duration get totalDuration =>
      steps.fold(Duration.zero, (sum, step) => sum + step.duration);

  /// Optional routine cover by file convention (Unified Media v0.7); callers
  /// fall back to the first exercise thumbnail when it is not on the device.
  String get coverPath => 'assets/covers/${id}_cover.webp';
}

final class MediaFile {
  const MediaFile({
    required this.path,
    required this.bytes,
    required this.sha256,
  });

  final String path;
  final int bytes;
  final String sha256;
}

final class MediaAsset {
  const MediaAsset({
    required this.id,
    required this.version,
    required this.kind,
    required this.locale,
    required this.files,
    required this.reviewStatus,
    required this.demoOnly,
    required this.aiGenerated,
    required this.rights,
    required this.accessibilityDescription,
  });

  /// File-name convention of the series packages (05_Content_Catalog_And_Series.md).
  static const thumbnailFileName = 'thumbnail.png';

  final String id;
  final int version;
  final MediaKind kind;
  final String locale;
  final List<MediaFile> files;
  final ReviewStatus reviewStatus;
  final bool demoOnly;
  final bool aiGenerated;
  final String rights;
  final String accessibilityDescription;

  String? get thumbnailPath {
    for (final file in files) {
      if (file.path.endsWith('/$thumbnailFileName')) return file.path;
    }
    return null;
  }
}

final class ContentCatalog {
  ContentCatalog({
    required this.catalogId,
    required this.catalogVersion,
    required this.locale,
    required this.demoOnly,
    required List<Exercise> exercises,
    required List<Routine> routines,
    required List<MediaAsset> mediaAssets,
  }) : exercises = List.unmodifiable(exercises),
       routines = List.unmodifiable(routines),
       mediaAssets = List.unmodifiable(mediaAssets),
       _exercisesByKey = {for (final e in exercises) _key(e.id, e.version): e},
       _mediaById = {for (final m in mediaAssets) m.id: m};

  final String catalogId;
  final String catalogVersion;
  final String locale;
  final bool demoOnly;
  final List<Exercise> exercises;
  final List<Routine> routines;
  final List<MediaAsset> mediaAssets;
  final Map<String, Exercise> _exercisesByKey;
  final Map<String, MediaAsset> _mediaById;

  static String _key(String id, int version) => '$id@$version';

  Exercise? exercise(String id, int version) =>
      _exercisesByKey[_key(id, version)];

  Exercise exerciseFor(RoutineStep step) =>
      _exercisesByKey[_key(step.exerciseId, step.exerciseVersion)]!;

  MediaAsset? media(String id) => _mediaById[id];

  /// Latest visible version of an exercise.
  Exercise? exerciseById(String id) {
    Exercise? latest;
    for (final e in exercises) {
      if (e.id == id && (latest == null || e.version > latest.version)) {
        latest = e;
      }
    }
    return latest;
  }

  /// Latest visible version of a routine.
  Routine? routine(String id) {
    Routine? latest;
    for (final r in routines) {
      if (r.id == id && (latest == null || r.version > latest.version)) {
        latest = r;
      }
    }
    return latest;
  }

  BodyPosition positionOf(Routine routine) {
    final positions = {
      for (final step in routine.steps) exerciseFor(step).position,
    };
    return positions.length == 1 ? positions.single : BodyPosition.mixed;
  }

  /// Series thumbnail, else the first instruction frame (step-photo series).
  String? thumbnailOf(Exercise exercise) =>
      media(exercise.posterMediaId)?.thumbnailPath ??
      exercise.steps.first.framePath;

  /// True when any part of the routine is not approved for real practice.
  bool isPreviewOnly(Routine routine) =>
      routine.demoOnly ||
      routine.reviewStatus != ReviewStatus.approved ||
      routine.steps.any((step) {
        final exercise = exerciseFor(step);
        return exercise.demoOnly ||
            exercise.reviewStatus != ReviewStatus.approved;
      });

  /// Size of the files in [requiredFilesOf], from the manifest.
  int bytesOf(Routine routine) {
    final sizes = {
      for (final m in mediaAssets)
        for (final f in m.files) f.path: f.bytes,
    };
    return requiredFilesOf(routine)
        .fold(0, (sum, path) => sum + (sizes[path] ?? 0));
  }

  /// Every bundled/downloaded file the player needs for [routine].
  Set<String> requiredFilesOf(Routine routine) => {
    for (final step in routine.steps) ...[
      for (final s in exerciseFor(step).steps) s.framePath,
      ?thumbnailOf(exerciseFor(step)),
    ],
  };
}
