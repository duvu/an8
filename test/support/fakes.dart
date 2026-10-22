import 'dart:io';

import 'package:an_nhien/core/clock/app_clock.dart';
import 'package:an_nhien/core/audio/cue_player.dart';
import 'package:an_nhien/core/audio/music_player.dart';
import 'package:an_nhien/features/health/application/health_export.dart';
import 'package:an_nhien/core/clock/clock_provider.dart';
import 'package:an_nhien/core/platform/screen_awake.dart';
import 'package:an_nhien/features/session/presentation/media_preloader.dart';
import 'package:an_nhien/features/settings/application/preferences_controller.dart';
import 'package:an_nhien/features/settings/application/reminder_actions.dart';
import 'package:an_nhien/features/splash/application/splash_providers.dart';
import 'package:an_nhien/features/settings/domain/break_reminder.dart';
import 'package:an_nhien/features/settings/domain/preferences.dart';
import 'package:an_nhien/features/settings/domain/reminder_scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:an_nhien/data/local/app_database.dart';
import 'package:an_nhien/features/catalog/application/catalog_providers.dart';
import 'package:an_nhien/features/catalog/data/catalog_data_source.dart';
import 'package:an_nhien/features/catalog/data/content_catalog_repository.dart';
import 'package:an_nhien/features/catalog/domain/content_visibility.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../features/catalog/catalog_test_data.dart' as data;

final class FakeClock implements AppClock {
  FakeClock({DateTime? start}) : _wall = start ?? DateTime(2026, 10, 18, 7);

  Duration _mono = Duration.zero;
  DateTime _wall;

  void advance(Duration by) {
    _mono += by;
    _wall = _wall.add(by);
  }

  @override
  Duration monotonic() => _mono;

  @override
  DateTime now() => _wall;
}

final class StringCatalogSource implements CatalogDataSource {
  StringCatalogSource([String? manifest])
    : manifest = manifest ?? data.readManifest();

  final String manifest;

  @override
  Future<String> readManifest() async => manifest;
}

Future<Database> openTestDatabase() {
  sqfliteFfiInit();
  return AppDatabase.open(databaseFactoryFfiNoIsolate, inMemoryDatabasePath);
}

/// Common overrides: real manifest (preview content allowed unless disabled),
/// fake clock, in-memory DB.
final class FakeScreenAwake implements ScreenAwake {
  bool enabled = false;

  @override
  Future<void> enable() async => enabled = true;

  @override
  Future<void> disable() async => enabled = false;
}

final class FakeCuePlayer implements CuePlayer {
  final played = <SoundCue>[];
  bool preloaded = false;

  @override
  Future<void> preload() async => preloaded = true;

  @override
  void play(SoundCue cue) => played.add(cue);

  @override
  Future<void> dispose() async {}
}

final class FakeMusicPlayer implements MusicPlayer {
  /// 'play:<track>', 'pause', 'stop' in call order.
  final calls = <String>[];

  @override
  void play(MusicTrack track) => calls.add('play:${track.name}');

  @override
  void pause() => calls.add('pause');

  @override
  void stop() => calls.add('stop');

  @override
  Future<void> dispose() async {}
}

/// Records what would have gone to the share sheet.
final class FakeFileSharer implements FileSharer {
  final shared = <({String path, String mimeType})>[];

  @override
  Future<void> share(
    File file, {
    required String mimeType,
    String? subject,
  }) async => shared.add((path: file.path, mimeType: mimeType));
}

final class FakeMediaPreloader implements MediaPreloader {
  FakeMediaPreloader({this.succeed = true});

  bool succeed;

  @override
  Future<bool> preload(BuildContext context, Set<String> paths) async =>
      succeed;
}

/// One fake behind the three small scheduler interfaces.
final class FakeReminderScheduler
    implements
        NotificationPermission,
        DailyReminderScheduler,
        BreakReminderScheduler {
  FakeReminderScheduler({this.grant = true});

  bool grant;
  int permissionRequests = 0;
  int? scheduledMinutes;
  List<int> breakTimes = const [];
  BreakAlert? breakAlert;

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return grant;
  }

  @override
  Future<void> scheduleDaily(
    int minutesOfDay, {
    required String title,
    required String body,
  }) async => scheduledMinutes = minutesOfDay;

  @override
  Future<void> cancel() async => scheduledMinutes = null;

  @override
  Future<void> scheduleBreaks(
    List<int> minutesOfDay, {
    required String title,
    required List<String> bodies,
    required BreakAlert alert,
  }) async {
    breakTimes = minutesOfDay;
    breakAlert = alert;
  }

  @override
  Future<void> cancelBreaks() async => breakTimes = const [];
}

List<Override> _reminderOverrides(FakeReminderScheduler fake) => [
  notificationPermissionProvider.overrideWithValue(fake),
  dailyReminderSchedulerProvider.overrideWithValue(fake),
  breakReminderSchedulerProvider.overrideWithValue(fake),
];

List<Override> testOverrides({
  required Database db,
  AppClock? clock,
  ScreenAwake? screenAwake,
  MediaPreloader? preloader,
  Preferences preferences = const Preferences(onboardingCompleted: true),
  FakeReminderScheduler? reminders,
  bool splash = false,
  String? manifest,
  bool allowPreviewContent = true,
  CuePlayer? cues,
  MusicPlayer? music,
  FileSharer? sharer,
}) => [
  fileSharerProvider.overrideWithValue(sharer ?? FakeFileSharer()),
  exportDirectoryProvider.overrideWithValue(
    () async => Directory.systemTemp.createTempSync('an_export_'),
  ),
  cuePlayerProvider.overrideWithValue(cues ?? FakeCuePlayer()),
  musicPlayerProvider.overrideWithValue(music ?? FakeMusicPlayer()),
  initialPreferencesProvider.overrideWithValue(preferences),
  splashEnabledProvider.overrideWithValue(splash),
  ..._reminderOverrides(reminders ?? FakeReminderScheduler()),
  screenAwakeProvider.overrideWithValue(screenAwake ?? FakeScreenAwake()),
  mediaPreloaderProvider.overrideWithValue(preloader ?? FakeMediaPreloader()),
  databaseProvider.overrideWithValue(db),
  if (clock != null) appClockProvider.overrideWithValue(clock),
  contentVisibilityProvider.overrideWithValue(
    ContentVisibility(allowPreviewContent: allowPreviewContent),
  ),
  catalogRepositoryProvider.overrideWithValue(
    DefaultContentCatalogRepository(
      dataSource: StringCatalogSource(manifest),
      visibility: ContentVisibility(allowPreviewContent: allowPreviewContent),
    ),
  ),
];
