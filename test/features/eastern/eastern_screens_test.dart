import 'package:an_nhien/app/app.dart';
import 'package:an_nhien/app/router/app_router.dart';
import 'package:an_nhien/app/router/app_routes.dart';
import 'package:an_nhien/features/eastern/presentation/eastern_form_screen.dart';
import 'package:an_nhien/features/eastern/presentation/eastern_overview_screen.dart';
import 'package:an_nhien/features/eastern/presentation/eastern_system_detail_screen.dart';
import 'package:an_nhien/features/eastern/presentation/eastern_systems_screen.dart';
import 'package:an_nhien/features/library/presentation/library_screen.dart';
import 'package:an_nhien/features/routine/presentation/routine_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_app.dart';

Future<void> _openEastern(WidgetTester tester) async {
  await tester.tap(find.text('Bài tập'));
  await settleScreen(tester);
  await tester.tap(find.text('Dưỡng sinh phương Đông'));
  // Wait for the screen itself: the library also has a "Bát Đoạn Cẩm" tag chip.
  await pumpUntilFound(
    tester,
    find.descendant(
      of: find.byType(EasternSystemsScreen),
      matching: find.text('Bát Đoạn Cẩm'),
    ),
  );
}

Future<void> _openSystem(WidgetTester tester, String title) async {
  await _openEastern(tester);
  final item = find.descendant(
    of: find.byType(EasternSystemsScreen),
    matching: find.text(title),
  );
  await tester.scrollUntilVisible(
    item,
    200,
    scrollable: mainScrollable(EasternSystemsScreen),
  );
  await tester.tap(item);
  await pumpUntilFound(tester, find.byType(EasternSystemDetailScreen));
  await settleScreen(tester);
}

Future<void> _scrollTo(WidgetTester tester, Finder finder) =>
    tester.scrollUntilVisible(
      finder,
      200,
      scrollable: mainScrollable(EasternSystemDetailScreen),
    );

void main() {
  testWidgets('library lists the six systems; only Bát Đoạn Cẩm is playable', (
    tester,
  ) async {
    final app = await pumpTestApp(tester);
    await _openEastern(tester);

    expect(find.byType(EasternSystemsScreen), findsOneWidget);
    expect(find.text('Đã có bài tập'), findsOneWidget);
    for (final title in [
      'Thái Cực Quyền 24 thức',
      'Tẩy Tủy Kinh / Tẩy Tủy Công',
    ]) {
      await tester.scrollUntilVisible(
        find.text(title),
        200,
        scrollable: mainScrollable(EasternSystemsScreen),
      );
    }
    expect(find.text('Đang nghiên cứu nguồn'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('Bát Đoạn Cẩm (D13) offers practice that opens its routine', (
    tester,
  ) async {
    final app = await pumpTestApp(tester);
    await _openSystem(tester, 'Bát Đoạn Cẩm');

    expect(find.text('Đã có bài tập'), findsOneWidget);
    expect(find.text('Đang chuẩn bị – chưa có bài tập'), findsNothing);
    await tester.tap(find.text('Tập bài Bát Đoạn Cẩm'));
    await pumpUntilFound(tester, find.byType(RoutineDetailScreen));
    await settleScreen(tester);
    expect(find.text('Bát Đoạn Cẩm 10 phút'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('a published form shows its real steps and no warning', (
    tester,
  ) async {
    final app = await pumpTestApp(tester);
    await _openSystem(tester, 'Bát Đoạn Cẩm');
    final form = find.text('1. Song thủ thác thiên');
    await _scrollTo(tester, form);
    // The history section above can leave it at the bottom edge.
    await tester.ensureVisible(form);
    await settleScreen(tester);
    await tester.tap(form);
    await pumpUntilFound(tester, find.byType(EasternFormScreen));

    expect(find.text('1. Đứng thẳng, thả lỏng.'), findsOneWidget);
    expect(find.textContaining('Không tập theo ảnh này'), findsNothing);
    await app.dispose();
  });

  testWidgets('systems without published media stay in preparation', (
    tester,
  ) async {
    final app = await pumpTestApp(tester);
    await _openSystem(tester, 'Dịch Cân Kinh');

    expect(find.text('Đang chuẩn bị – chưa có bài tập'), findsOneWidget);
    expect(find.textContaining('Tập bài'), findsNothing);
    expect(find.byType(FilledButton), findsNothing);
    await app.dispose();
  });

  testWidgets('Thái Cực 24 overview boards open full screen with a notice', (
    tester,
  ) async {
    final app = await pumpTestApp(tester);
    ProviderScope.containerOf(tester.element(find.byType(AnNhienApp)))
        .read(appRouterProvider)
        .push(AppRoutes.easternSystem('taichi24'));
    await pumpUntilFound(tester, find.byType(EasternSystemDetailScreen));
    await settleScreen(tester);
    final header = find.text('Bảng tổng quan các thức');
    await _scrollTo(tester, header);
    expect(
      find.textContaining('không tập theo tranh này', skipOffstage: false),
      findsOneWidget,
    );
    final board = find.text('Thức 9–16');
    await _scrollTo(tester, board);
    await tester.tap(board);
    await pumpUntilFound(tester, find.byType(EasternOverviewScreen));
    await settleScreen(tester);

    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) =>
            w is Image &&
            w.semanticLabel ==
                'Bảng tổng quan Thái Cực Quyền 24 thức, Thức 9–16',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('không tập theo tranh này'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('systems without boards have no overview section', (
    tester,
  ) async {
    final app = await pumpTestApp(tester);
    await _openSystem(tester, 'Dịch Cân Kinh');
    expect(
      find.text('Bảng tổng quan các thức', skipOffstage: false),
      findsNothing,
    );
    await app.dispose();
  });

  testWidgets('an unpublished form card keeps the do-not-practise notice', (
    tester,
  ) async {
    final app = await pumpTestApp(tester);
    await _openSystem(tester, 'Dịch Cân Kinh');
    final first = find.textContaining('1. Vi Đà hiến chử');
    await _scrollTo(tester, first);
    await tester.tap(first);
    await pumpUntilFound(tester, find.byType(EasternFormScreen));

    expect(find.textContaining('Không tập theo ảnh này'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('forms without any own image are not illustrated or tappable', (
    tester,
  ) async {
    final app = await pumpTestApp(tester);
    await _openSystem(tester, 'Dịch Cân Kinh');
    final e210 = find.text('10. Ngọa hổ phác thực');
    await _scrollTo(tester, e210);
    final tile = tester.widget<ListTile>(
      find.ancestor(of: e210, matching: find.byType(ListTile)),
    );
    expect(tile.onTap, isNull);
    expect(tile.leading, isNull);
    await app.dispose();
  });

  testWidgets('research-only system explains why there are no forms', (
    tester,
  ) async {
    final app = await pumpTestApp(tester);
    await _openSystem(tester, 'Tẩy Tủy Kinh / Tẩy Tủy Công');
    await _scrollTo(tester, find.textContaining('Chưa xác định phiên bản'));
    expect(find.text('Các thức'), findsNothing);
    await app.dispose();
  });

  testWidgets('introductions also show in production builds (D09)', (
    tester,
  ) async {
    final app = await pumpTestApp(tester, allowPreviewContent: false);
    await tester.tap(find.text('Bài tập'));
    await settleScreen(tester);
    expect(
      find.descendant(
        of: find.byType(LibraryScreen),
        matching: find.text('Dưỡng sinh phương Đông'),
      ),
      findsOneWidget,
    );
    await app.dispose();
  });

  testWidgets('library entry counts the playable systems', (tester) async {
    final app = await pumpTestApp(tester);
    await tester.tap(find.text('Bài tập'));
    await pumpUntilFound(
      tester,
      find.text('6 hệ truyền thống · 1 hệ đã có bài tập'),
    );
    expect(find.textContaining('đang chuẩn bị bài tập'), findsNothing);
    await app.dispose();
  });
}
