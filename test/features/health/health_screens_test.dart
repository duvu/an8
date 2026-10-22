import 'package:an_nhien/app/app.dart';
import 'package:an_nhien/app/router/app_router.dart';
import 'package:an_nhien/app/router/app_routes.dart';
import 'package:an_nhien/features/health/data/sqlite_health_repository.dart';
import 'package:an_nhien/features/health/domain/health_metric.dart';
import 'package:an_nhien/features/health/domain/measurement.dart';
import 'package:an_nhien/features/health/presentation/add_measurement_screen.dart';
import 'package:an_nhien/features/health/presentation/health_metric_screen.dart';
import 'package:an_nhien/features/health/presentation/health_screen.dart';
import 'package:an_nhien/features/health/presentation/health_widgets.dart';
import 'package:an_nhien/features/settings/application/preferences_controller.dart';
import 'package:an_nhien/features/settings/domain/preferences.dart';
import 'package:an_nhien/features/settings/presentation/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_app.dart';

const _boxes = ['Tâm thu', 'Tâm trương', 'Nhịp tim'];

const _consented = Preferences(onboardingCompleted: true, healthConsent: true);

Future<TestApp> _open(
  WidgetTester tester, {
  Preferences preferences = _consented,
  List<Measurement> seed = const [],
}) async {
  final app = await pumpTestApp(tester, preferences: preferences);
  if (seed.isNotEmpty) {
    await tester.runAsync(() async {
      final repo = SqliteHealthRepository(app.db);
      for (final m in seed) {
        await repo.add(m);
      }
    });
  }
  await tester.tap(find.text('Sức khỏe'));
  await settleIo(tester);
  await settleScreen(tester);
  return app;
}

Future<void> _go(WidgetTester tester, String location) async {
  ProviderScope.containerOf(tester.element(find.byType(AnNhienApp)))
      .read(appRouterProvider)
      .push(location);
  await settleIo(tester);
  await settleScreen(tester);
}

Measurement _reading(
  String id,
  HealthMetric metric,
  double value,
  DateTime at, {
  double? second,
}) => Measurement(
  id: id,
  metric: metric,
  value: value,
  secondValue: second,
  measuredAt: at,
);

Future<void> _enter(WidgetTester tester, String label, String text) async {
  final field = find.widgetWithText(TextField, label);
  await tester.ensureVisible(field);
  await tester.enterText(field, text);
}

/// Types "128/78/72" box by box, as read off the monitor.
Future<void> _enterPressure(WidgetTester tester, String line) async {
  for (final (i, part) in line.split('/').indexed) {
    await _enter(tester, _boxes[i], part);
  }
}

FocusNode _focusOf(WidgetTester tester, String label) =>
    tester.widget<TextField>(find.widgetWithText(TextField, label)).focusNode!;

String _textOf(WidgetTester tester, String label) => tester
    .widget<TextField>(find.widgetWithText(TextField, label))
    .controller!
    .text;

Future<void> _save(WidgetTester tester) async {
  await tester.tap(find.widgetWithText(FilledButton, 'Lưu'));
  await settleIo(tester);
  await settleScreen(tester);
}

void main() {
  testWidgets('asks for consent before any health data is kept', (
    tester,
  ) async {
    final app = await _open(
      tester,
      preferences: const Preferences(onboardingCompleted: true),
    );
    expect(find.text('Theo dõi chỉ số sức khỏe'), findsOneWidget);
    expect(find.text('Ghi chỉ số'), findsNothing);

    await tester.tap(find.text('Đồng ý và bắt đầu'));
    await settleIo(tester);
    await settleScreen(tester);
    expect(find.text('Ghi chỉ số'), findsOneWidget);
    final prefs = ProviderScope.containerOf(
      tester.element(find.byType(HealthScreen)),
    ).read(preferencesProvider);
    expect(prefs.healthConsent, isTrue);
    await app.dispose();
  });

  testWidgets('logging a normal blood pressure shows it on the overview', (
    tester,
  ) async {
    final app = await _open(tester);
    await tester.tap(find.text('Ghi chỉ số'));
    await pumpUntilFound(tester, find.byType(AddMeasurementScreen));
    await settleScreen(tester);

    await _enterPressure(tester, '128/82');
    await _save(tester);

    expect(find.text('Đã lưu số đo.'), findsOneWidget);
    expect(find.byType(HealthScreen), findsOneWidget);
    expect(find.text('128/82 mmHg'), findsOneWidget);
    expect(find.text('Trong khoảng tham khảo'), findsOneWidget);
    expect(find.text('76 lần/phút'), findsNothing); // no pulse given
    await app.dispose();
  });

  testWidgets('"128/78/72" saves blood pressure and heart rate together', (
    tester,
  ) async {
    final app = await _open(tester);
    await _go(tester, AppRoutes.healthAdd('bloodPressure'));
    await _enterPressure(tester, '128/78/72');
    await _save(tester);

    expect(find.text('Đã lưu số đo.'), findsOneWidget);
    expect(find.text('128/78 mmHg'), findsOneWidget);
    expect(find.text('72 lần/phút'), findsOneWidget);
    final rows = (await tester.runAsync(
      () => app.db.query('health_measurements', orderBy: 'metric'),
    ))!;
    expect(rows.map((r) => r['metric']), ['bloodPressure', 'heartRate']);
    expect(rows[0]['measured_at'], rows[1]['measured_at']);
    await app.dispose();
  });

  testWidgets('a malformed pressure line explains the format', (tester) async {
    final app = await _open(tester);
    await _go(tester, AppRoutes.healthAdd('bloodPressure'));
    await _enterPressure(tester, '128');
    await _save(tester);
    expect(
      find.text('Hãy nhập cả số tâm thu và số tâm trương.'),
      findsOneWidget,
    );
    await app.dispose();
  });

  testWidgets('a high pulse from the monitor adds its own advice', (
    tester,
  ) async {
    final app = await _open(tester);
    await _go(tester, AppRoutes.healthAdd('bloodPressure'));
    await _enterPressure(tester, '125/80/110');
    await _save(tester);
    expect(find.text('Ngoài khoảng tham khảo'), findsOneWidget);
    expect(find.textContaining('trên 100 lần/phút'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('a very high blood pressure shows the 115 advice', (
    tester,
  ) async {
    final app = await _open(tester);
    await _go(tester, AppRoutes.healthAdd('bloodPressure'));
    await _enterPressure(tester, '185/110');
    await _save(tester);

    expect(find.text('Cần chú ý'), findsOneWidget);
    expect(find.textContaining('gọi 115 ngay'), findsOneWidget);
    await tester.tap(find.text('Tôi đã hiểu'));
    await settleScreen(tester);
    expect(find.byType(AddMeasurementScreen), findsNothing);
    await app.dispose();
  });

  testWidgets('swapped blood pressure numbers are rejected, not saved', (
    tester,
  ) async {
    final app = await _open(tester);
    await _go(tester, AppRoutes.healthAdd('bloodPressure'));
    await _enterPressure(tester, '80/120');
    await _save(tester);

    expect(
      find.text('Số trên (tâm thu) phải lớn hơn số dưới (tâm trương).'),
      findsOneWidget,
    );
    expect(find.byType(AddMeasurementScreen), findsOneWidget);
    final rows = (await tester.runAsync(
      () => app.db.query('health_measurements'),
    ))!;
    expect(rows, isEmpty);
    await app.dispose();
  });

  testWidgets('glucose in mg/dL is stored in mmol/L with its timing', (
    tester,
  ) async {
    final app = await _open(tester);
    await _go(tester, AppRoutes.healthAdd('bloodGlucose'));
    await tester.tap(find.text('mg/dL'));
    await tester.pump();
    await _enter(tester, 'Giá trị (mg/dL)', '126');
    final fasting = find.text('Lúc đói');
    await tester.ensureVisible(fasting);
    await tester.tap(fasting);
    await tester.pump();
    await _save(tester);

    // 126 mg/dL = 7.0 mmol/L: at the fasting limit.
    expect(find.text('Ngoài khoảng tham khảo'), findsOneWidget);
    await tester.tap(find.text('Tôi đã hiểu'));
    await settleIo(tester);
    await settleScreen(tester);
    expect(find.text('7,0 mmol/L · Lúc đói'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('BMI from the latest weight and height (Asian cut-offs)', (
    tester,
  ) async {
    final app = await _open(
      tester,
      seed: [
        _reading('w', HealthMetric.weight, 60, DateTime(2026, 10, 1)),
        _reading('h', HealthMetric.height, 160, DateTime(2026, 1, 1)),
      ],
    );
    expect(find.text('BMI'), findsOneWidget);
    expect(find.text('23,4'), findsOneWidget);
    expect(find.text('Thừa cân (mức tham khảo người châu Á)'), findsOneWidget);
    expect(
      find.text('Cân nặng tham khảo với chiều cao 160 cm: 47,4–58,8 kg'),
      findsOneWidget,
    );
    expect(
      find.text('Cân nặng hiện tại nhiều hơn mức trên 1,2 kg.'),
      findsOneWidget,
    );
    expect(find.textContaining('hỏi bác sĩ trước khi đặt'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('height alone already gives the reference weight range', (
    tester,
  ) async {
    final app = await _open(
      tester,
      seed: [_reading('h', HealthMetric.height, 155, DateTime(2026, 1, 1))],
    );
    expect(find.text('Ghi cân nặng để tính BMI.'), findsOneWidget);
    expect(
      find.text('Cân nặng tham khảo với chiều cao 155 cm: 44,5–55,2 kg'),
      findsOneWidget,
    );
    await app.dispose();
  });

  testWidgets('a weight inside the range says so, with no advice', (
    tester,
  ) async {
    final app = await _open(
      tester,
      seed: [
        _reading('w', HealthMetric.weight, 55, DateTime(2026, 10, 1)),
        _reading('h', HealthMetric.height, 160, DateTime(2026, 1, 1)),
      ],
    );
    expect(
      find.text('Cân nặng hiện tại nằm trong khoảng này.'),
      findsOneWidget,
    );
    expect(find.textContaining('hỏi bác sĩ trước khi đặt'), findsNothing);
    await app.dispose();
  });

  testWidgets('unintended weight loss over 6 months is pointed out', (
    tester,
  ) async {
    final app = await _open(
      tester,
      seed: [
        _reading('w1', HealthMetric.weight, 60, DateTime(2026, 5, 1)),
        _reading('w2', HealthMetric.weight, 56.5, DateTime(2026, 10, 1)),
      ],
    );
    expect(find.textContaining('giảm từ 5% trở lên'), findsOneWidget);
    await app.dispose();
  });

  test('chart x position follows real time, not reading index', () {
    final a = DateTime(2026, 10, 1);
    final c = DateTime(2026, 10, 11);
    expect(chartTimeFraction(a, a, c), 0);
    expect(chartTimeFraction(DateTime(2026, 10, 2), a, c), closeTo(0.1, 1e-9));
    expect(chartTimeFraction(c, a, c), 1);
    expect(chartTimeFraction(a, a, a), 0.5);
  });

  testWidgets('a metric shows its chart and readings can be deleted', (
    tester,
  ) async {
    final app = await _open(
      tester,
      seed: [
        _reading('p1', HealthMetric.heartRate, 72, DateTime(2026, 10, 1)),
        _reading('p2', HealthMetric.heartRate, 76, DateTime(2026, 10, 2)),
      ],
    );
    await _go(tester, AppRoutes.healthMetric('heartRate'));
    expect(find.byType(HealthMetricScreen), findsOneWidget);
    expect(find.byType(HealthChart), findsOneWidget);
    expect(find.text('76 lần/phút'), findsOneWidget);

    final delete = find.byTooltip('Xóa số đo').first;
    await tester.ensureVisible(delete);
    await tester.tap(delete);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xóa'));
    await settleIo(tester);
    await settleScreen(tester);

    expect(find.text('76 lần/phút'), findsNothing);
    expect(find.byType(HealthChart), findsNothing); // one reading left
    await app.dispose();
  });

  testWidgets('Settings erases every reading and withdraws consent', (
    tester,
  ) async {
    final app = await _open(
      tester,
      seed: [_reading('w', HealthMetric.weight, 60, DateTime(2026, 10, 1))],
    );
    await tester.tap(find.text('Cài đặt'));
    await settleScreen(tester);
    final erase = find.text('Xóa toàn bộ dữ liệu sức khỏe');
    await tester.scrollUntilVisible(
      erase,
      200,
      scrollable: mainScrollable(SettingsScreen),
    );
    await tester.drag(mainScrollable(SettingsScreen), const Offset(0, -200));
    await tester.pumpAndSettle();
    await tester.tap(erase);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xóa'));
    await settleIo(tester);
    await settleScreen(tester);

    expect(find.text('Đã xóa toàn bộ dữ liệu sức khỏe.'), findsOneWidget);
    final rows = (await tester.runAsync(
      () => app.db.query('health_measurements'),
    ))!;
    expect(rows, isEmpty);
    await tester.tap(find.text('Sức khỏe'));
    await settleScreen(tester);
    expect(find.text('Đồng ý và bắt đầu'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('Save stays above the on-screen keyboard (L-014)', (
    tester,
  ) async {
    final app = await _open(tester);
    await _go(tester, AppRoutes.healthAdd('bloodPressure'));
    // Keyboard taking 300 dp of the 780 dp screen.
    tester.view.viewInsets = const FakeViewPadding(bottom: 900);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();

    final save = tester.getRect(find.widgetWithText(FilledButton, 'Lưu'));
    expect(save.bottom, lessThanOrEqualTo(780 - 300));
    await tester.tap(find.widgetWithText(FilledButton, 'Lưu'));
    await tester.pump();
    await tester.pump();
    // The error sits right under the boxes, above the keyboard too.
    final error = find.text('Hãy nhập cả số tâm thu và số tâm trương.');
    expect(tester.getRect(error).bottom, lessThanOrEqualTo(780 - 300));
    await app.dispose();
  });

  testWidgets('pressure boxes use the plain number pad (no "/" needed)', (
    tester,
  ) async {
    final app = await _open(tester);
    await _go(tester, AppRoutes.healthAdd('bloodPressure'));
    for (final label in _boxes) {
      final box = tester.widget<TextField>(
        find.widgetWithText(TextField, label),
      );
      expect(box.keyboardType, TextInputType.number, reason: label);
    }
    // Opens ready to type into the first box.
    expect(_focusOf(tester, 'Tâm thu').hasFocus, isTrue);
    await app.dispose();
  });

  testWidgets('a complete number moves on to the next box', (tester) async {
    final app = await _open(tester);
    await _go(tester, AppRoutes.healthAdd('bloodPressure'));
    await _enter(tester, 'Tâm thu', '12');
    await tester.pump();
    expect(_focusOf(tester, 'Tâm thu').hasFocus, isTrue); // may be 120–129
    await _enter(tester, 'Tâm thu', '128');
    await tester.pump();
    expect(_focusOf(tester, 'Tâm trương').hasFocus, isTrue);
    await _enter(tester, 'Tâm trương', '10');
    await tester.pump();
    expect(_focusOf(tester, 'Tâm trương').hasFocus, isTrue); // may be 100+
    await _enter(tester, 'Tâm trương', '78');
    await tester.pump();
    expect(_focusOf(tester, 'Nhịp tim').hasFocus, isTrue);
    await app.dispose();
  });

  testWidgets('a separator key moves on; a pasted line fills every box', (
    tester,
  ) async {
    final app = await _open(tester);
    await _go(tester, AppRoutes.healthAdd('bloodPressure'));
    await _enter(tester, 'Tâm thu', '95 ');
    await tester.pump();
    expect(_textOf(tester, 'Tâm thu'), '95');
    expect(_focusOf(tester, 'Tâm trương').hasFocus, isTrue);

    await _enter(tester, 'Tâm thu', '128/78/72');
    await tester.pump();
    expect(_boxes.map((b) => _textOf(tester, b)), ['128', '78', '72']);
    await _save(tester);
    expect(find.text('128/78 mmHg'), findsOneWidget);
    expect(find.text('72 lần/phút'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('the keyboard ✓ key saves too', (tester) async {
    final app = await _open(tester);
    await _go(tester, AppRoutes.healthAdd('bloodPressure'));
    await _enterPressure(tester, '120/80/70');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await settleIo(tester);
    await settleScreen(tester);
    expect(find.text('120/80 mmHg'), findsOneWidget);
    await app.dispose();
  });
}
