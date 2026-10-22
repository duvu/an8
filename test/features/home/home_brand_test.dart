import 'package:an_brand/an_brand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_app.dart';

void main() {
  testWidgets('Home shows the An lockup, never the old name', (tester) async {
    final app = await pumpTestApp(tester);
    expect(
      find.descendant(of: find.byType(AppBar), matching: find.byType(AnLockup)),
      findsOneWidget,
    );
    expect(find.textContaining('An Nhiên'), findsNothing);
    await app.dispose();
  });
}
