import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../../../core/audio/cue_player.dart';
import '../../../core/audio/music_player.dart';
import '../../../core/platform/screen_awake.dart';
import '../../../core/ui/async_value_view.dart';
import '../../settings/application/preferences_controller.dart';
import '../application/session_controller.dart';
import '../application/session_cues.dart';
import '../application/session_music.dart';
import '../domain/session_machine.dart';
import 'distance_timer_view.dart';
import 'pause_dialog.dart';
import 'media_preloader.dart';

class SessionPlayerScreen extends ConsumerStatefulWidget {
  const SessionPlayerScreen({super.key, required this.routineId});

  final String routineId;

  @override
  ConsumerState<SessionPlayerScreen> createState() =>
      _SessionPlayerScreenState();
}

class _SessionPlayerScreenState extends ConsumerState<SessionPlayerScreen> {
  late final AppLifecycleListener _lifecycle;
  late final ScreenAwake _screenAwake;
  late final MusicPlayer _music;

  late final _provider = sessionControllerProvider(widget.routineId);

  SessionController get _controller => ref.read(_provider.notifier);

  @override
  void initState() {
    super.initState();
    _screenAwake = ref.read(screenAwakeProvider);
    _screenAwake.enable();
    _music = ref.read(musicPlayerProvider);
    // Calls, audio-focus loss, backgrounding and screen lock all pass through
    // inactive/hidden/paused: pause and wait for the user (PRD F03).
    _lifecycle = AppLifecycleListener(
      onInactive: _interrupt,
      onHide: _interrupt,
      onPause: _interrupt,
      onResume: _askAfterInterruption,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _screenAwake.disable();
    _music.stop();
    super.dispose();
  }

  void _interrupt() => _controller.interrupt();

  /// Back from a call / lock screen: offer continue or stop right away.
  void _askAfterInterruption() {
    final status = ref.read(_provider).value?.snapshot.status;
    if (status == SessionStatus.interrupted) _askPaused();
  }

  Future<void> _start() async {
    if (ref.read(preferencesProvider).soundCues) {
      unawaited(ref.read(cuePlayerProvider).preload());
    }
    await ref.read(_provider.future);
    await _controller.start();
    await _prepareMedia();
  }

  Future<void> _prepareMedia() async {
    final plan = ref.read(_provider).requireValue.plan;
    final ok = await ref
        .read(mediaPreloaderProvider)
        .preload(context, plan.framePaths);
    if (!mounted) return;
    ok
        ? _controller.mediaReady()
        : _controller.mediaFailed(AppLocalizations.of(context).playerError);
  }

  bool _dialogOpen = false;

  /// "Tạm dừng" (and Back): pause at once, then continue or stop for good.
  Future<void> _pauseAndAsk() async {
    _controller.pause();
    await _askPaused();
  }

  Future<void> _askPaused() async {
    if (_dialogOpen) return;
    _dialogOpen = true;
    final choice = await showPauseDialog(context);
    _dialogOpen = false;
    if (!mounted) return;
    switch (choice) {
      case PauseChoice.resume:
        _controller.resume();
      case PauseChoice.stop:
        _controller.exit();
      case null: // dismissed: stay paused; the big button offers "Tiếp tục"
    }
  }

  /// Music follows the session: on while it runs, paused otherwise, stopped
  /// at the end.
  void _syncMusic(SessionViewState? previous, SessionViewState view) {
    if (!ref.read(preferencesProvider).backgroundMusic) return;
    final status = view.snapshot.status;
    if (status == SessionStatus.finished) return _music.stop();
    final was = previous != null && musicShouldPlay(previous.snapshot.status);
    final now = musicShouldPlay(status);
    if (now && !was) _music.play(musicFor(view.plan.routine));
    if (!now && was) _music.pause();
  }

  void _retry() {
    _controller.retry();
    _prepareMedia();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(_provider, (previous, next) {
      final view = next.value;
      if (view == null) return;
      if (ref.read(preferencesProvider).soundCues) {
        final cues = ref.read(cuePlayerProvider);
        for (final cue in sessionCues(previous?.value, view)) {
          cues.play(cue);
        }
      }
      _syncMusic(previous?.value, view);
      if (view.snapshot.status == SessionStatus.finished) {
        context.pushReplacement(AppRoutes.summary(view.sessionId!));
      }
    });
    final prefs = ref.watch(preferencesProvider);
    final reduceMotion =
        prefs.reducedMotion || MediaQuery.disableAnimationsOf(context);
    final l10n = AppLocalizations.of(context);

    // The player has a single layout: the distance view (phone 1–2 m away).
    Widget body(SessionViewState view) => DistanceTimerView(
      view: view,
      showCaptions: prefs.captionsEnabled,
      reduceMotion: reduceMotion,
      header: _PlayerHeader(
        stepLabel: l10n.playerStepCounter(
          view.snapshot.stepIndex + 1,
          view.plan.steps.length,
        ),
      ),
      onPause: _pauseAndAsk,
      onResume: _controller.resume,
      onPrevious: _controller.previous,
      onNext: _controller.next,
      onRetry: _retry,
      onSkip: _controller.skipFailedStep,
      onBack: _pauseAndAsk,
    );

    return Theme(
      data: AppTheme.night,
      // Light status-bar icons on the dark background.
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _pauseAndAsk();
          },
          child: Scaffold(
            body: SafeArea(
              child: AsyncValueView(
                value: ref.watch(_provider),
                onRetry: () => ref.invalidate(_provider),
                data: body,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Step counter. Stopping is offered by the pause panel (no separate Stop).
class _PlayerHeader extends StatelessWidget {
  const _PlayerHeader({required this.stepLabel});

  final String stepLabel;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerRight,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Text(stepLabel, style: Theme.of(context).textTheme.titleMedium),
    ),
  );
}
