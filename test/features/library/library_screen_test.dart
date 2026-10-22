import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:an_nhien/features/library/presentation/library_screen.dart';

import '../../support/test_app.dart';

void main() {
  testWidgets('bottom navigation opens the library with demo labels', (
    tester,
  ) async {
    final app = await pumpTestApp(tester);
    await tester.tap(find.text('Bài tập'));
    await tester.pumpAndSettle();
    await settleIo(tester); // asset manifest is real I/O

    await tester.scrollUntilVisible(
      find.text('6 bài'),
      100,
      scrollable: mainScrollable(LibraryScreen),
    );
    expect(find.text('DEMO CONTENT'), findsNothing);
    expect(find.text('Có sẵn trên máy'), findsWidgets);
    await app.dispose();
  });

  testWidgets('filters narrow results; empty state offers clearing', (
    tester,
  ) async {
    final app = await pumpTestApp(tester);
    await tester.tap(find.text('Bài tập'));
    await tester.pumpAndSettle();
    await settleIo(tester); // asset manifest is real I/O

    final longChip = find.widgetWithText(ChoiceChip, 'Trên 10 phút');
    await tester.ensureVisible(longChip);
    await tester.tap(longChip);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('1 bài'),
      100,
      scrollable: mainScrollable(LibraryScreen),
    );

    await tester.scrollUntilVisible(
      find.byType(TextField),
      -100,
      scrollable: mainScrollable(LibraryScreen),
    );
    await tester.enterText(find.byType(TextField), 'không có bài này');
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Xóa bộ lọc'),
      100,
      scrollable: mainScrollable(LibraryScreen),
    );
    expect(find.text('Không có bài phù hợp với bộ lọc.'), findsOneWidget);

    await tester.tap(find.text('Xóa bộ lọc'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byType(TextField),
      -100,
      scrollable: mainScrollable(LibraryScreen),
    );
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      isEmpty,
    );
    await tester.scrollUntilVisible(
      find.text('6 bài'),
      100,
      scrollable: mainScrollable(LibraryScreen),
    );
    await app.dispose();
  });
}
