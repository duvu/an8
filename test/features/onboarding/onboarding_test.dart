import 'package:an_nhien/features/onboarding/presentation/onboarding_screen.dart';
import 'package:an_nhien/features/settings/data/sqlite_preferences_repository.dart';
import 'package:an_nhien/features/settings/domain/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';
import '../../support/test_app.dart';

void main() {
  testWidgets(
    'first launch shows onboarding without asking for personal data',
    (tester) async {
      final app = await pumpTestApp(tester, preferences: const Preferences());
      expect(find.text('Dưỡng sinh nhẹ nhàng mỗi ngày'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
      expect(find.byType(NavigationBar), findsNothing);
      await app.dispose();
    },
  );

  testWidgets('skip completes onboarding and opens Home', (tester) async {
    final app = await pumpTestApp(tester, preferences: const Preferences());
    await tester.tap(find.text('Bỏ qua'));
    await tester.pumpAndSettle();
    await settleIo(tester);

    expect(find.text('Hôm nay mình tập nhẹ nhé.'), findsOneWidget);
    final saved = await tester.runAsync(
      () => SqlitePreferencesRepository(app.db).load(),
    );
    expect(saved!.onboardingCompleted, isTrue);
    await app.dispose();
  });

  testWidgets(
    'choosing "Ngồi" suggests a seated routine without hiding others',
    (tester) async {
      final reminders = FakeReminderScheduler();
      final app = await pumpTestApp(
        tester,
        preferences: const Preferences(),
        reminders: reminders,
      );
      await tester.tap(find.text('Tiếp tục'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ChoiceChip, 'Ngồi'));
      await tester.pump();
      // Logo + one goal chip per catalog tag push the button below the fold
      // (and out of the lazily built list).
      await tester.scrollUntilVisible(
        find.text('Khám phá bài tập'),
        200,
        scrollable: mainScrollable(OnboardingScreen),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Khám phá bài tập'));
      await tester.pumpAndSettle();
      await settleIo(tester);

      // R05 is the only all-seated routine; it is featured with the Start CTA.
      final featuredCard = find.ancestor(
        of: find.widgetWithText(FilledButton, 'Bắt đầu'),
        matching: find.byType(Card),
      );
      expect(
        find.descendant(
          of: featuredCard,
          matching: find.text('Thư giãn buổi tối 6 phút'),
        ),
        findsOneWidget,
      );
      expect(find.text('Khởi động nhẹ', skipOffstage: false), findsOneWidget);
      expect(
        reminders.permissionRequests,
        0,
      ); // no permission prompt during onboarding
      await app.dispose();
    },
  );
}
