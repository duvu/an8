import 'package:an_nhien/features/calendar/application/calendar_controller.dart';
import 'package:an_nhien/features/calendar/presentation/calendar_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_app.dart';

void main() {
  // FakeClock starts on 18 Oct 2026, 07:00.
  Future<TestApp> openCalendar(WidgetTester tester) async {
    final app = await pumpTestApp(tester);
    await tester.tap(find.byTooltip('Xem lịch'));
    await tester.pumpAndSettle();
    return app;
  }

  testWidgets('opens from Home on today with solar and lunar dates', (
    tester,
  ) async {
    final app = await openCalendar(tester);
    expect(find.byType(CalendarScreen), findsOneWidget);
    expect(find.text('Tháng 10 năm 2026'), findsOneWidget);
    expect(find.text('Chủ nhật, 18 tháng 10 năm 2026'), findsOneWidget);
    expect(find.textContaining('Âm lịch: ngày'), findsOneWidget);
    expect(find.textContaining('Tiết khí:'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('selecting a day shows its almanac and the cell says so', (
    tester,
  ) async {
    final app = await openCalendar(tester);
    // 22/10/2025 is a reference day (Giáp Tý): go to it through the controller.
    final container = ProviderScope.containerOf(
      tester.element(find.byType(CalendarScreen)),
    );
    container
        .read(calendarControllerProvider.notifier)
        .select(DateTime(2025, 10, 22));
    await tester.pumpAndSettle();

    expect(find.text('Tháng 10 năm 2025'), findsOneWidget);
    expect(
      find.textContaining('Ngày Giáp Tý · Tháng Bính Tuất'),
      findsOneWidget,
    );
    expect(find.text('Ngày hắc đạo · Thiên Lao'), findsOneWidget);
    expect(find.textContaining('Trực Mãn'), findsOneWidget);
    expect(find.text('Nên làm, kỵ theo từng việc'), findsOneWidget);
    expect(find.text('Cưới hỏi: Nên tránh'), findsOneWidget);
    expect(find.text('Khai trương: Bình thường'), findsOneWidget);
    expect(find.text('Ngược: ngày hắc đạo (Thiên Lao)'), findsWidgets);
    expect(find.text('Thuận: sao Cơ'), findsWidgets);
    expect(find.text('Sao Cơ (Thủy, Báo (beo))'), findsOneWidget);
    expect(find.text('Kiết tú (sao tốt)'), findsOneWidget);
    expect(
      find.textContaining('Kiêng cữ: Đóng giường, lót giường, đi thuyền.'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Hướng hỷ thần (cầu may): Đông Bắc'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Hướng tài thần (cầu tài): Đông Nam'),
      findsOneWidget,
    );
    expect(find.textContaining('Giờ Tý (23:00–01:00)'), findsWidgets);
    expect(
      find.bySemanticsLabel(
        RegExp(
          '^Thứ tư, ngày 22 tháng 10 năm 2025, âm lịch ngày 2 tháng 9, Ngày hắc đạo',
        ),
      ),
      findsOneWidget,
    );
    await app.dispose();
  });

  testWidgets('tapping a cell selects that day', (tester) async {
    final app = await openCalendar(tester);
    await tester.tap(
      find.bySemanticsLabel(RegExp('^Thứ ba, ngày 20 tháng 10 năm 2026')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Thứ ba, 20 tháng 10 năm 2026'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('month arrows move the month and keep a valid day', (
    tester,
  ) async {
    final app = await openCalendar(tester);
    await tester.tap(find.byTooltip('Tháng sau'));
    await tester.pumpAndSettle();
    expect(find.text('Tháng 11 năm 2026'), findsOneWidget);
    await tester.tap(find.byTooltip('Tháng trước'));
    await tester.tap(find.byTooltip('Tháng trước'));
    await tester.pumpAndSettle();
    expect(find.text('Tháng 9 năm 2026'), findsOneWidget);
    // 18th exists in every month, selection follows.
    expect(find.textContaining('18 tháng 9 năm 2026'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('Hôm nay returns to today', (tester) async {
    final app = await openCalendar(tester);
    await tester.tap(find.byTooltip('Tháng sau'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hôm nay'));
    await tester.pumpAndSettle();
    expect(find.text('Tháng 10 năm 2026'), findsOneWidget);
    expect(find.text('Chủ nhật, 18 tháng 10 năm 2026'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('the disclaimer is always on the page', (tester) async {
    final app = await openCalendar(tester);
    await tester.scrollUntilVisible(
      find.textContaining('chưa được chuyên gia thẩm định'),
      200,
      scrollable: mainScrollable(CalendarScreen),
    );
    expect(
      find.textContaining('chưa được chuyên gia thẩm định'),
      findsOneWidget,
    );
    await app.dispose();
  });

  test('month grid covers whole weeks starting on Monday', () {
    final days = monthGridDays(DateTime(2026, 10));
    expect(days.length % 7, 0);
    expect(days.first.weekday, DateTime.monday);
    expect(days.last.weekday, DateTime.sunday);
    expect(days.first, DateTime(2026, 9, 28));
    expect(days.last, DateTime(2026, 11, 1));
  });
}
