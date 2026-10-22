import 'package:an_nhien/features/catalog/presentation/routine_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_app.dart';

void main() {
  testWidgets('routine cards and detail use the bundled routine cover', (
    tester,
  ) async {
    final app = await pumpTestApp(tester);
    await settleScreen(tester); // asset manifest is real I/O

    String? imageOf(Finder routineImage) =>
        (tester
                    .widget<Image>(
                      find.descendant(
                        of: routineImage,
                        matching: find.byType(Image),
                      ),
                    )
                    .image
                as AssetImage)
            .assetName;

    expect(
      imageOf(find.byType(RoutineImage).first),
      'assets/covers/R01_cover.webp',
    );

    await tester.tap(find.text('Khởi động nhẹ').first);
    await settleScreen(tester);
    expect(
      imageOf(find.byType(RoutineImage).last),
      'assets/covers/R01_cover.webp',
    );
    await app.dispose();
  });
}
