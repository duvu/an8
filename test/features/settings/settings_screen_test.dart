import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:an_nhien/features/settings/presentation/settings_screen.dart';

import '../../support/fakes.dart';
import '../../support/test_app.dart';

void main() {
  testWidgets('enabling the reminder with permission denied shows guidance', (
    tester,
  ) async {
    final reminders = FakeReminderScheduler(grant: false);
    final app = await pumpTestApp(tester, reminders: reminders);
    await tester.tap(find.text('Cài đặt'));
    await tester.pumpAndSettle();

    // Lift the tile clear of the bottom navigation bar before tapping.
    await tester.drag(mainScrollable(SettingsScreen), const Offset(0, -300));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(SwitchListTile, 'Nhắc tập mỗi ngày'));
    await tester.pump();
    await settleIo(tester);
    await tester.pump(const Duration(milliseconds: 100));

    expect(reminders.permissionRequests, 1);
    expect(
      find.text(
        'Chưa được cấp quyền thông báo. Bạn có thể bật trong Cài đặt của điện thoại.',
      ),
      findsOneWidget,
    );
    final tile = tester.widget<SwitchListTile>(
      find.widgetWithText(SwitchListTile, 'Nhắc tập mỗi ngày'),
    );
    expect(tile.value, isFalse);
    await app.dispose();
  });

  testWidgets('turning captions off hides instructions in the player', (
    tester,
  ) async {
    final app = await pumpTestApp(tester);
    await tester.tap(find.text('Cài đặt'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(SwitchListTile, 'Hiện lời hướng dẫn'));
    await tester.pump();
    await settleIo(tester);

    await tester.tap(find.text('Hôm nay'));
    await tester.pumpAndSettle();
    final start = find.widgetWithText(FilledButton, 'Bắt đầu');
    await tester.ensureVisible(start);
    await tester.tap(start);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tôi đã đọc, bắt đầu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await settleIo(tester);
    await app.elapse(const Duration(seconds: 4));

    expect(find.text('Thở tự nhiên'), findsOneWidget);
    expect(find.text('Ngồi vững, vai và hàm thả lỏng.'), findsNothing);
    await app.dispose();
  });

  testWidgets('downloads screen lists offline status and size', (tester) async {
    final app = await pumpTestApp(tester);
    await tester.tap(find.text('Cài đặt'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Bài đã tải'),
      100,
      scrollable: mainScrollable(SettingsScreen),
    );
    await tester.tap(find.text('Bài đã tải'));
    await tester.pumpAndSettle();
    await settleIo(tester);

    final status = find.textContaining(
      'Có sẵn trên máy ·',
      skipOffstage: false,
    );
    expect(status, findsNWidgets(6));
    expect(find.textContaining('MB', skipOffstage: false), findsNWidgets(6));
    await app.dispose();
  });
}
