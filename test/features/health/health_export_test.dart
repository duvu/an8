import 'dart:convert';
import 'dart:io';

import 'package:an_nhien/app/app.dart';
import 'package:an_nhien/app/router/app_router.dart';
import 'package:an_nhien/app/router/app_routes.dart';
import 'package:an_nhien/features/health/data/sqlite_health_repository.dart';
import 'package:an_nhien/features/health/domain/health_metric.dart';
import 'package:an_nhien/features/health/domain/measurement.dart';
import 'package:an_nhien/features/health/presentation/health_export_screen.dart';
import 'package:an_nhien/features/settings/domain/preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';
import '../../support/test_app.dart';

const _consented = Preferences(onboardingCompleted: true, healthConsent: true);

Future<TestApp> _openExport(
  WidgetTester tester,
  FakeFileSharer sharer, {
  List<Measurement> seed = const [],
}) async {
  final app = await pumpTestApp(
    tester,
    preferences: _consented,
    sharer: sharer,
  );
  await tester.runAsync(() async {
    final repo = SqliteHealthRepository(app.db);
    for (final m in seed) {
      await repo.add(m);
    }
  });
  ProviderScope.containerOf(tester.element(find.byType(AnNhienApp)))
      .read(appRouterProvider)
      .push(AppRoutes.healthExport);
  await settleIo(tester);
  await settleScreen(tester);
  return app;
}

/// Export writes real files (and renders a PNG), so it runs outside the
/// fake-async zone until the share sheet would open.
Future<void> _tapAndWaitForShare(
  WidgetTester tester,
  Finder button,
  FakeFileSharer sharer,
) async {
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  await tester.runAsync(() async {
    await tester.tap(button);
    for (var i = 0; i < 100 && sharer.shared.isEmpty; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
  });
  await tester.pump();
}

final _seed = [
  Measurement(
    id: 'bp1',
    metric: HealthMetric.bloodPressure,
    value: 128,
    secondValue: 78,
    measuredAt: DateTime(2026, 10, 19, 7),
    note: 'sau khi đi bộ, mệt',
  ),
  Measurement(
    id: 'bp2',
    metric: HealthMetric.bloodPressure,
    value: 131,
    secondValue: 80,
    measuredAt: DateTime(2026, 10, 20, 7),
  ),
  Measurement(
    id: 'w1',
    metric: HealthMetric.weight,
    value: 62.5,
    measuredAt: DateTime(2026, 10, 20, 7),
  ),
];

void main() {
  testWidgets('CSV holds every reading in Vietnamese, oldest first', (
    tester,
  ) async {
    final sharer = FakeFileSharer();
    final app = await _openExport(tester, sharer, seed: _seed);
    await _tapAndWaitForShare(
      tester,
      find.text('Xuất file CSV (mở bằng Excel)'),
      sharer,
    );

    final shared = sharer.shared.single;
    expect(shared.mimeType, 'text/csv');
    expect(shared.path, endsWith('an-suc-khoe-20261018-0700.csv'));
    final bytes = (await tester.runAsync(
      () => File(shared.path).readAsBytes(),
    ))!;
    // UTF-8 BOM so Excel shows Vietnamese correctly.
    expect(bytes.take(3), [0xEF, 0xBB, 0xBF]);
    final lines = utf8.decode(bytes.sublist(3)).trim().split('\r\n');
    expect(lines.first, startsWith('Ngày giờ đo,Chỉ số,Giá trị'));
    expect(lines, hasLength(4));
    expect(
      lines[1],
      '2026-10-19 07:00,Huyết áp,128,78,mmHg,,"sau khi đi bộ, mệt"',
    );
    expect(lines.last, '2026-10-20 07:00,Cân nặng,62.5,,kg,,');
    await app.dispose();
  });

  testWidgets('image export shares the previewed summary as PNG', (
    tester,
  ) async {
    final sharer = FakeFileSharer();
    final app = await _openExport(tester, sharer, seed: _seed);
    expect(find.text('Sổ theo dõi sức khỏe'), findsOneWidget);

    await _tapAndWaitForShare(tester, find.text('Xuất ảnh tóm tắt'), sharer);

    final shared = sharer.shared.single;
    expect(shared.mimeType, 'image/png');
    final bytes = (await tester.runAsync(
      () => File(shared.path).readAsBytes(),
    ))!;
    // PNG signature.
    expect(bytes.take(4), [0x89, 0x50, 0x4E, 0x47]);
    expect(latin1.decode(bytes.sublist(12, 16)), 'IHDR');
    await app.dispose();
  });

  testWidgets('nothing to export without readings', (tester) async {
    final sharer = FakeFileSharer();
    final app = await _openExport(tester, sharer);
    expect(find.byType(HealthExportScreen), findsOneWidget);
    expect(find.text('Chưa có số đo nào để xuất.'), findsOneWidget);
    expect(find.text('Xuất file CSV (mở bằng Excel)'), findsNothing);
    await app.dispose();
  });

  testWidgets('the overview links to export', (tester) async {
    final app = await pumpTestApp(tester, preferences: _consented);
    await tester.tap(find.text('Sức khỏe'));
    await settleIo(tester);
    await settleScreen(tester);
    await tester.tap(find.text('Xuất dữ liệu (CSV, ảnh)'));
    await pumpUntilFound(tester, find.byType(HealthExportScreen));
    await app.dispose();
  });
}
