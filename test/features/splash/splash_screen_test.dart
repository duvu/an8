import 'package:an_brand/an_brand.dart';
import 'package:an_nhien/app/theme/component_tokens.dart';
import 'package:an_nhien/features/settings/domain/preferences.dart';
import 'package:an_nhien/features/splash/presentation/splash_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_app.dart';

void main() {
  Future<TestApp> pumpSplash(
    WidgetTester tester, {
    Preferences preferences = const Preferences(onboardingCompleted: true),
  }) async {
    final app = await pumpTestApp(
      tester,
      preferences: preferences,
      splash: true,
    );
    return app;
  }

  testWidgets('shows the logo in the middle with the slogan under it', (
    tester,
  ) async {
    final app = await pumpSplash(tester);
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(AnLockup), findsOneWidget);
    expect(find.text('Cho người hữu duyên'), findsOneWidget);

    final screen = tester.getRect(find.byType(SplashScreen));
    final logo = tester.getRect(find.byType(AnLockup));
    final slogan = tester.getRect(find.text('Cho người hữu duyên'));
    // Visible artwork (left share of the image) is centred horizontally.
    final artworkWidth = logo.width * SplashTokens.lockupContentWidthFactor;
    expect(logo.left + artworkWidth / 2, closeTo(screen.center.dx, 1));
    expect(slogan.center.dx, closeTo(screen.center.dx, 1));
    expect(slogan.top, greaterThan(logo.bottom));
    // Block (logo + slogan) is centred vertically.
    expect(
      (logo.top + slogan.bottom) / 2,
      closeTo(screen.center.dy, screen.height * 0.05),
    );
    await tester.pumpAndSettle();
    await app.dispose();
  });

  testWidgets('moves on to Home by itself', (tester) async {
    final app = await pumpSplash(tester);
    await tester.pump(SplashTokens.hold);
    await tester.pumpAndSettle();
    expect(find.byType(SplashScreen), findsNothing);
    expect(find.text('Hôm nay mình tập nhẹ nhé.'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('first-time users continue to onboarding', (tester) async {
    final app = await pumpSplash(tester, preferences: const Preferences());
    await tester.pump(SplashTokens.hold);
    await tester.pumpAndSettle();
    expect(find.text('Dưỡng sinh nhẹ nhàng mỗi ngày'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('leaving early cancels the timer (no pending timers)', (
    tester,
  ) async {
    final app = await pumpSplash(tester);
    await app.dispose();
  });
}
