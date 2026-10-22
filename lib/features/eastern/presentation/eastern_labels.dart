import '../../../app/localization/generated/app_localizations.dart';
import '../domain/practice_system.dart';

extension EasternLabels on AppLocalizations {
  String easternStatus(PracticeSystem s, {required bool playable}) => playable
      ? easternPlayable
      : (s.researchOnly ? easternResearch : easternPreparing);

  /// Known levels from the content pack; unknown values show as-is.
  String? easternLevel(String? level) => switch (level) {
    null => null,
    'gentle-to-moderate' => easternLevelGentleToModerate,
    'moderate' => easternLevelModerate,
    _ => level,
  };
}
