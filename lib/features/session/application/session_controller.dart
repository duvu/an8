import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/clock/app_clock.dart';
import '../../../core/clock/clock_provider.dart';
import '../../../core/id/id_generator.dart';
import '../../catalog/application/catalog_providers.dart';
import '../domain/session_machine.dart';
import '../domain/session_plan.dart';
import 'session_providers.dart';
import 'session_recorder.dart';

final class SessionViewState {
  const SessionViewState({
    required this.plan,
    required this.snapshot,
    this.sessionId,
  });

  final SessionPlan plan;
  final SessionSnapshot snapshot;

  /// Set once the session record exists.
  final String? sessionId;

  PlannedStep get currentStep => plan.steps[snapshot.stepIndex];

  Duration get stepOffset =>
      snapshot.position - plan.timeline.startOf(snapshot.stepIndex);

  Duration get stepRemaining => currentStep.duration - stepOffset;

  Duration get totalRemaining => plan.timeline.total - snapshot.position;

  bool get hasNext => snapshot.stepIndex < plan.steps.length - 1;
}

final sessionControllerProvider = AsyncNotifierProvider.autoDispose
    .family<SessionController, SessionViewState, String>(SessionController.new);

/// ViewModel of the player: owns the [SessionMachine], refreshes the view from
/// the monotonic clock and persists the session record.
class SessionController extends AsyncNotifier<SessionViewState> {
  SessionController(this.routineId);

  static const refreshInterval = Duration(milliseconds: 200);

  final String routineId;
  late AppClock _clock;
  late SessionRecorder _recorder;
  late SessionMachine _machine;
  late SessionPlan _plan;
  Timer? _refresh;

  @override
  Future<SessionViewState> build() async {
    // read, not watch: a running session stays pinned to the catalog it started with.
    _clock = ref.read(appClockProvider);
    _recorder = SessionRecorder(
      ref.read(sessionRepositoryProvider),
      _clock,
      ref.read(idGeneratorProvider),
    );
    final catalog = await ref.read(catalogProvider.future);
    final routine = catalog.routine(routineId);
    if (routine == null) throw StateError('Unknown routine $routineId');
    _plan = SessionPlan.from(catalog, routine);
    _machine = SessionMachine(_plan.timeline);
    ref.onDispose(_onDispose);
    return _view();
  }

  /// Creates the session record and waits for the media to be ready.
  Future<void> start() async {
    if (_machine.status != SessionStatus.idle) return;
    _machine.prepare();
    // begin() sets the record synchronously, so the first view has its id.
    final saving = _recorder.begin(_plan);
    _emit();
    await saving;
  }

  void mediaReady() => _apply(_machine.mediaReady);

  void mediaFailed(String message) =>
      _apply((now) => _machine.mediaFailed(now, message));

  void retry() {
    _machine.prepare();
    _emit();
  }

  void skipFailedStep() => _apply(_machine.skipFailedStep);

  void pause() => _apply(_machine.pause, persist: true);

  void interrupt() => _apply(_machine.interrupt, persist: true);

  void resume() => _apply(_machine.resume);

  void next() => _apply(_machine.next);

  void previous() => _apply((now) => _machine.previous(now));

  void exit() => _apply(_machine.exit);

  void _apply(void Function(Duration now) event, {bool persist = false}) {
    event(_clock.monotonic());
    _emit();
    if (persist) unawaited(_persistProgress());
  }

  SessionViewState _view() => SessionViewState(
    plan: _plan,
    snapshot: _machine.snapshot(_clock.monotonic()),
    sessionId: _recorder.sessionId,
  );

  void _emit() {
    final view = _view();
    state = AsyncData(view);
    final running = switch (view.snapshot.status) {
      SessionStatus.countdown || SessionStatus.playing => true,
      _ => false,
    };
    if (running) {
      _refresh ??= Timer.periodic(refreshInterval, (_) => _emit());
    } else {
      _refresh?.cancel();
      _refresh = null;
    }
    if (view.snapshot.outcome case final outcome?) {
      unawaited(_recorder.finish(outcome, view.snapshot.activeTime));
    }
  }

  Future<void> _persistProgress() =>
      _recorder.saveProgress(_machine.snapshot(_clock.monotonic()).activeTime);

  /// Leaving the player without an explicit exit still records an honest outcome.
  void _onDispose() {
    _refresh?.cancel();
    _machine.exit(_clock.monotonic());
    final snapshot = _machine.snapshot(_clock.monotonic());
    if (snapshot.outcome case final outcome?) {
      unawaited(_recorder.finish(outcome, snapshot.activeTime));
    }
  }
}
