import 'package:an_nhien/features/session/application/session_controller.dart';
import 'package:an_nhien/features/session/application/session_providers.dart';
import 'package:an_nhien/features/session/domain/session_machine.dart';
import 'package:an_nhien/features/session/domain/workout_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';

void main() {
  late FakeClock clock;
  late ProviderContainer container;
  final provider = sessionControllerProvider('R01'); // 3 steps x 2 min

  setUp(() async {
    clock = FakeClock();
    final db = await openTestDatabase();
    container = ProviderContainer(
      overrides: testOverrides(db: db, clock: clock),
    );
    addTearDown(() async {
      container.dispose();
      await db.close();
    });
  });

  Future<SessionController> startedController() async {
    container.listen(provider, (_, _) {});
    await container.read(provider.future);
    final controller = container.read(provider.notifier);
    await controller.start();
    controller.mediaReady();
    return controller;
  }

  SessionViewState view() => container.read(provider).requireValue;

  Future<WorkoutSession> record() async {
    // Let fire-and-forget writes land.
    await Future<void>.delayed(Duration.zero);
    return (await container
        .read(sessionRepositoryProvider)
        .byId(view().sessionId!))!;
  }

  test(
    'creates an in-progress record pinned to routine and catalog version',
    () async {
      await startedController();
      final r = await record();
      expect(r.status, WorkoutStatus.inProgress);
      expect(r.routineId, 'R01');
      expect(r.routineVersion, 1);
      expect(r.catalogVersion, '2026.10.18.3');
    },
  );

  test('derives current step, frame and remaining times', () async {
    final controller = await startedController();
    clock.advance(const Duration(seconds: 3 + 125)); // countdown + 2:05
    controller.pause();
    final v = view();
    expect(v.snapshot.stepIndex, 1);
    expect(v.currentStep.exercise.id, 'E02');
    expect(v.stepRemaining, const Duration(seconds: 115));
    expect(v.totalRemaining, const Duration(seconds: 235));
    expect(v.currentStep.frameAt(v.stepOffset).order, 1);
  });

  test('completion records completed with exact active seconds', () async {
    final controller = await startedController();
    clock.advance(const Duration(seconds: 3 + 60));
    controller.pause();
    clock.advance(const Duration(minutes: 10)); // paused time is not counted
    controller.resume();
    clock.advance(const Duration(minutes: 30));
    controller.next(); // any event observes completion
    final r = await record();
    expect(view().snapshot.outcome, SessionOutcome.completed);
    expect(r.status, WorkoutStatus.completed);
    expect(r.activeTime, const Duration(minutes: 6));
    expect(r.finishedAt, isNotNull);
  });

  test('early exit records abandoned with played time only', () async {
    final controller = await startedController();
    clock.advance(const Duration(seconds: 3 + 90));
    controller.exit();
    final r = await record();
    expect(r.status, WorkoutStatus.abandoned);
    expect(r.activeTime, const Duration(seconds: 90));
  });

  test('exit after a system interruption records interrupted', () async {
    final controller = await startedController();
    clock.advance(const Duration(seconds: 3 + 30));
    controller.interrupt();
    expect(view().snapshot.status, SessionStatus.interrupted);
    expect((await record()).activeTime, const Duration(seconds: 30));
    controller.exit();
    expect((await record()).status, WorkoutStatus.interrupted);
  });

  test('disposing the player mid-session records abandoned', () async {
    final controller = await startedController();
    clock.advance(const Duration(seconds: 13));
    final id = view().sessionId!;
    controller.pause();
    container.invalidate(provider);
    await Future<void>.delayed(Duration.zero);
    final r = await container.read(sessionRepositoryProvider).byId(id);
    expect(r!.status, WorkoutStatus.abandoned);
    expect(r.activeTime, const Duration(seconds: 10));
  });
}
