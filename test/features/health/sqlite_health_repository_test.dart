import 'package:an_nhien/features/health/data/sqlite_health_repository.dart';
import 'package:an_nhien/features/health/domain/health_metric.dart';
import 'package:an_nhien/features/health/domain/measurement.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';

void main() {
  late SqliteHealthRepository repo;

  setUp(() async {
    final db = await openTestDatabase();
    repo = SqliteHealthRepository(db);
    addTearDown(() async {
      await repo.dispose();
      await db.close();
    });
  });

  Measurement m(
    String id,
    HealthMetric metric,
    double value,
    DateTime at, {
    double? second,
    GlucoseTiming? timing,
  }) => Measurement(
    id: id,
    metric: metric,
    value: value,
    secondValue: second,
    glucoseTiming: timing,
    measuredAt: at,
    note: id == 'bp1' ? 'sau khi đi bộ' : null,
  );

  test('round-trips every field, newest first', () async {
    await repo.add(
      m(
        'bp1',
        HealthMetric.bloodPressure,
        128,
        DateTime(2026, 10, 1, 7),
        second: 82,
      ),
    );
    await repo.add(
      m(
        'bp2',
        HealthMetric.bloodPressure,
        131,
        DateTime(2026, 10, 2, 7),
        second: 84,
      ),
    );
    await repo.add(
      m(
        'g1',
        HealthMetric.bloodGlucose,
        6.2,
        DateTime(2026, 10, 2, 6),
        timing: GlucoseTiming.fasting,
      ),
    );

    final bp = await repo.byMetric(HealthMetric.bloodPressure);
    expect(bp.map((e) => e.id), ['bp2', 'bp1']);
    expect(bp.last.secondValue, 82);
    expect(bp.last.note, 'sau khi đi bộ');
    expect(bp.last.measuredAt, DateTime(2026, 10, 1, 7));

    final glucose = await repo.byMetric(HealthMetric.bloodGlucose);
    expect(glucose.single.glucoseTiming, GlucoseTiming.fasting);
  });

  test('latest gives one reading per metric', () async {
    await repo.add(m('w1', HealthMetric.weight, 60, DateTime(2026, 9)));
    await repo.add(m('w2', HealthMetric.weight, 59, DateTime(2026, 10)));
    await repo.add(m('h1', HealthMetric.height, 158, DateTime(2026, 1)));

    final latest = await repo.latest();
    expect(
      latest.keys,
      unorderedEquals([HealthMetric.weight, HealthMetric.height]),
    );
    expect(latest[HealthMetric.weight]!.id, 'w2');
  });

  test('delete, delete all, and change notifications', () async {
    var changes = 0;
    final sub = repo.changes.listen((_) => changes++);
    addTearDown(sub.cancel);

    await repo.add(m('w1', HealthMetric.weight, 60, DateTime(2026, 9)));
    await repo.add(m('t1', HealthMetric.temperature, 36.8, DateTime(2026, 9)));
    await repo.delete('w1');
    expect(await repo.byMetric(HealthMetric.weight), isEmpty);
    await repo.deleteAll();
    expect(await repo.latest(), isEmpty);
    await pumpEventQueue();
    expect(changes, 4);
  });
}
