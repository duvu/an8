import '../../../app/localization/generated/app_localizations.dart';
import '../domain/catalog_models.dart';

extension CatalogLabels on AppLocalizations {
  String position(BodyPosition p) => switch (p) {
    BodyPosition.seated => positionSeated,
    BodyPosition.standing => positionStanding,
    BodyPosition.mixed => positionMixed,
  };

  String intensity(Intensity i) => switch (i) {
    Intensity.gentle => intensityGentle,
    Intensity.easy => intensityEasy,
    Intensity.moderate => intensityModerate,
  };

  /// Known catalog tags get Vietnamese labels; new tags show as-is until labelled.
  String tag(String tag) => switch (tag) {
    'starter' => tagStarter,
    'morning' => tagMorning,
    'evening' => tagEvening,
    'neck-shoulder' => tagNeckShoulder,
    'seated' => tagSeated,
    'gentle' => tagGentle,
    'baduanjin' => tagBaduanjin,
    'eastern-qigong' => tagEasternQigong,
    _ => tag,
  };

  /// Whole minutes, rounded up.
  String durationMinutes(Duration d) => minutes((d.inSeconds + 59) ~/ 60);

  String durationMinutesSeconds(Duration d) =>
      minutesSeconds(d.inMinutes, d.inSeconds % 60);

  String routineMeta(ContentCatalog catalog, Routine routine) {
    final intensities = {
      for (final s in routine.steps) catalog.exerciseFor(s).intensity,
    };
    // Report the most demanding intensity in the routine.
    final hardest = intensities.reduce((a, b) => a.index >= b.index ? a : b);
    return routineMetaLine(
      durationMinutes(routine.totalDuration),
      intensity(hardest),
      position(catalog.positionOf(routine)),
    );
  }
}
