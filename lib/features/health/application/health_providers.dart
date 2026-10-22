import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/app_database.dart';
import '../../../core/id/id_generator.dart';
import '../../settings/application/preferences_controller.dart';
import '../data/sqlite_health_repository.dart';
import '../domain/health_consent.dart';
import '../domain/health_metric.dart';
import '../domain/measurement.dart';
import '../domain/measurement_draft.dart';

final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  final repository = SqliteHealthRepository(ref.watch(databaseProvider));
  ref.onDispose(repository.dispose);
  return repository;
});

/// Reloads [ref]'s provider after every repository write.
HealthRepository _watchRepository(Ref ref) {
  final repository = ref.watch(healthRepositoryProvider);
  final subscription = repository.changes.listen((_) => ref.invalidateSelf());
  ref.onDispose(subscription.cancel);
  return repository;
}

final latestReadingsProvider = FutureProvider<Map<HealthMetric, Measurement>>(
  (ref) => _watchRepository(ref).latest(),
);

/// Newest first.
final readingsProvider = FutureProvider.family<List<Measurement>, HealthMetric>(
  (ref, metric) => _watchRepository(ref).byMetric(metric),
);

/// Stored with the other preferences (D18: consent is a device setting).
final healthConsentProvider = Provider<HealthConsent>(
  PreferencesHealthConsent.new,
);

final class PreferencesHealthConsent implements HealthConsent {
  PreferencesHealthConsent(this._ref);

  final Ref _ref;

  @override
  Future<void> setGiven({required bool given}) => _ref
      .read(preferencesProvider.notifier)
      .update((p) => p.copyWith(healthConsent: given));
}

/// Every reading grouped by metric, newest first. [readings] arrives oldest
/// first, as the repository returns it.
Map<HealthMetric, List<Measurement>> groupByMetric(List<Measurement> readings) {
  final byMetric = <HealthMetric, List<Measurement>>{};
  for (final r in readings.reversed) {
    (byMetric[r.metric] ??= []).add(r);
  }
  return byMetric;
}

final allByMetricProvider =
    FutureProvider.autoDispose<Map<HealthMetric, List<Measurement>>>(
      (ref) async => groupByMetric(await _watchRepository(ref).all()),
    );

final healthActionsProvider = Provider<HealthActions>(
  (ref) => HealthActions(
    ref.watch(healthRepositoryProvider),
    ref.watch(healthConsentProvider),
    ref.watch(idGeneratorProvider),
  ),
);

/// Writes; validation happens before (domain [validateMeasurement]).
final class HealthActions {
  const HealthActions(this._repository, this._consent, this._ids);

  final HealthRepository _repository;
  final HealthConsent _consent;
  final IdGenerator _ids;

  Future<Measurement> add({
    required HealthMetric metric,
    required double value,
    double? secondValue,
    GlucoseTiming? glucoseTiming,
    required DateTime measuredAt,
    String? note,
  }) async {
    final measurement = Measurement(
      id: _ids.next(),
      metric: metric,
      value: value,
      secondValue: secondValue,
      glucoseTiming: glucoseTiming,
      measuredAt: measuredAt,
      note: note == null || note.trim().isEmpty ? null : note.trim(),
    );
    await _repository.add(measurement);
    return measurement;
  }

  /// Stores every reading of a checked [draft] with its date and note.
  Future<List<Measurement>> addDraft(MeasurementDraft draft) async => [
    for (final r in draft.toReadings())
      await add(
        metric: r.metric,
        value: r.value,
        secondValue: r.secondValue,
        glucoseTiming: r.glucoseTiming,
        measuredAt: draft.measuredAt,
        note: draft.note,
      ),
  ];

  Future<void> delete(String id) => _repository.delete(id);

  Future<void> giveConsent() => _consent.setGiven(given: true);

  /// Erases every reading and withdraws consent (D18 retention).
  Future<void> deleteAllAndWithdraw() async {
    await _repository.deleteAll();
    await _consent.setGiven(given: false);
  }
}
