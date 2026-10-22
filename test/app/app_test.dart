import 'package:an_nhien/features/home/presentation/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../features/catalog/catalog_test_data.dart';
import '../support/test_app.dart';

void main() {
  testWidgets('official content shows no demo or review labels', (
    tester,
  ) async {
    final app = await pumpTestApp(tester);

    final context = tester.element(find.byType(HomeScreen));
    expect(Localizations.localeOf(context), const Locale('vi'));
    expect(find.text('Hôm nay mình tập nhẹ nhé.'), findsOneWidget);
    expect(find.text('Khởi động nhẹ'), findsOneWidget);
    expect(find.text('DEMO CONTENT'), findsNothing);
    expect(
      find.text('Bản xem trước — chưa phải hướng dẫn tập chính thức.'),
      findsNothing,
    );
    await app.dispose();
  });

  testWidgets('unreviewed draft content is still labelled as demo (P03)', (
    tester,
  ) async {
    final app = await pumpTestApp(tester, manifest: draftManifest());

    expect(find.text('DEMO CONTENT'), findsWidgets);
    expect(
      find.text('Bản xem trước — chưa phải hướng dẫn tập chính thức.'),
      findsOneWidget,
    );
    await app.dispose();
  });
}
