import '../../catalog/domain/catalog_models.dart';
import 'break_reminder.dart';

/// Device-local preferences. Health readings live in their own table, only
/// after [healthConsent] (D18).
final class Preferences {
  const Preferences({
    this.onboardingCompleted = false,
    this.position,
    this.goalTag,
    this.captionsEnabled = true,
    this.reducedMotion = false,
    this.soundCues = true,
    this.backgroundMusic = true,
    this.healthConsent = false,
    this.reminderEnabled = false,
    this.reminderMinutes = defaultReminderMinutes,
    this.breakReminderEnabled = false,
    this.breakIntervalMinutes = defaultBreakIntervalMinutes,
    this.breakStartMinutes = defaultBreakStartMinutes,
    this.breakEndMinutes = defaultBreakEndMinutes,
    this.breakAlert = defaultBreakAlert,
  });

  static const defaultReminderMinutes = 7 * 60;

  final bool onboardingCompleted;

  /// Preferred practice position; null = no preference.
  final BodyPosition? position;
  final String? goalTag;
  final bool captionsEnabled;
  final bool reducedMotion;

  /// Countdown, step-change, 10 s warning and completion sounds.
  final bool soundCues;

  /// Quiet looping music while a session runs (D17).
  final bool backgroundMusic;

  /// The user agreed to keep health readings on this device (D18).
  final bool healthConsent;
  final bool reminderEnabled;

  /// Local time of the daily reminder, minutes after midnight.
  final int reminderMinutes;

  /// Repeating "stand up and move" reminders between [breakStartMinutes] and
  /// [breakEndMinutes] (D24); all times are minutes after midnight.
  final bool breakReminderEnabled;
  final int breakIntervalMinutes;
  final int breakStartMinutes;
  final int breakEndMinutes;
  final BreakAlert breakAlert;

  Preferences copyWith({
    bool? onboardingCompleted,
    BodyPosition? Function()? position,
    String? Function()? goalTag,
    bool? captionsEnabled,
    bool? reducedMotion,
    bool? soundCues,
    bool? backgroundMusic,
    bool? healthConsent,
    bool? reminderEnabled,
    int? reminderMinutes,
    bool? breakReminderEnabled,
    int? breakIntervalMinutes,
    int? breakStartMinutes,
    int? breakEndMinutes,
    BreakAlert? breakAlert,
  }) => Preferences(
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    position: position != null ? position() : this.position,
    goalTag: goalTag != null ? goalTag() : this.goalTag,
    captionsEnabled: captionsEnabled ?? this.captionsEnabled,
    reducedMotion: reducedMotion ?? this.reducedMotion,
    soundCues: soundCues ?? this.soundCues,
    backgroundMusic: backgroundMusic ?? this.backgroundMusic,
    healthConsent: healthConsent ?? this.healthConsent,
    reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    reminderMinutes: reminderMinutes ?? this.reminderMinutes,
    breakReminderEnabled: breakReminderEnabled ?? this.breakReminderEnabled,
    breakIntervalMinutes: breakIntervalMinutes ?? this.breakIntervalMinutes,
    breakStartMinutes: breakStartMinutes ?? this.breakStartMinutes,
    breakEndMinutes: breakEndMinutes ?? this.breakEndMinutes,
    breakAlert: breakAlert ?? this.breakAlert,
  );
}

abstract interface class PreferencesRepository {
  Future<Preferences> load();
  Future<void> save(Preferences preferences);
}
