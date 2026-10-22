import 'package:an_nhien/app/app.dart';
import 'package:an_nhien/app/router/app_router.dart';
import 'package:an_nhien/app/router/app_routes.dart';
import 'package:an_nhien/features/eastern/presentation/eastern_form_screen.dart';
import 'package:an_nhien/features/eastern/presentation/eastern_system_detail_screen.dart';
import 'package:an_nhien/features/eastern/presentation/eastern_systems_screen.dart';
import 'package:an_nhien/features/learn/presentation/exercise_learn_screen.dart';
import 'package:an_nhien/features/learn/presentation/story_episode_screen.dart';
import 'package:an_nhien/features/routine/presentation/routine_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_app.dart';

const _disclaimer =
    'Nội dung tìm hiểu do An biên tập, chưa được chuyên gia thẩm định. '
    'Đây không phải hướng dẫn kỹ thuật hay lời khuyên y tế.';

Future<void> _go(WidgetTester tester, String location) async {
  ProviderScope.containerOf(tester.element(find.byType(AnNhienApp)))
      .read(appRouterProvider)
      .go(location);
  await settleScreen(tester);
  await settleIo(tester);
  await settleScreen(tester);
}

Future<void> _scrollTo(WidgetTester tester, Finder finder, Type screen) =>
    tester.scrollUntilVisible(finder, 200, scrollable: mainScrollable(screen));

void main() {
  testWidgets('a routine step opens its "Tìm hiểu" page', (tester) async {
    final app = await pumpTestApp(tester);
    await _go(tester, AppRoutes.routine('R02'));
    final step = find.textContaining('Thở tự nhiên');
    await _scrollTo(tester, step, RoutineDetailScreen);
    await tester.tap(step.first);
    await pumpUntilFound(tester, find.byType(ExerciseLearnScreen));
    await settleScreen(tester);

    expect(find.text('Ý nghĩa'), findsOneWidget);
    expect(find.text('Khi tập, hãy để ý'), findsOneWidget);
    await _scrollTo(tester, find.text(_disclaimer), ExerciseLearnScreen);
    await app.dispose();
  });

  testWidgets('a Bát Đoạn Cẩm form shows its meaning and sources', (
    tester,
  ) async {
    final app = await pumpTestApp(tester);
    await _go(tester, AppRoutes.easternForm('baduanjin', 'E101'));
    final meaning = find.textContaining('Hai tay như nâng bầu trời');
    await _scrollTo(tester, meaning, EasternFormScreen);
    expect(find.text('Tìm hiểu'), findsOneWidget);
    await _scrollTo(tester, find.text('Nguồn tham khảo'), EasternFormScreen);
    expect(
      find.textContaining('Origin of Ba Duan Jin', findRichText: true),
      findsOneWidget,
    );
    await app.dispose();
  });

  testWidgets('a system shows its history; legends stay legends', (
    tester,
  ) async {
    final app = await pumpTestApp(tester);
    await _go(tester, AppRoutes.easternSystem('yijinjing'));
    await _scrollTo(
      tester,
      find.text('Lịch sử và văn hóa'),
      EasternSystemDetailScreen,
    );
    await _scrollTo(
      tester,
      find.textContaining('không phải sự kiện lịch sử đã được xác nhận'),
      EasternSystemDetailScreen,
    );
    await app.dispose();
  });

  testWidgets('stories are read, not played', (tester) async {
    final app = await pumpTestApp(tester);
    await _go(tester, AppRoutes.eastern);
    final story = find.text('Tám đoạn gấm và câu chuyện Bát Đoạn Cẩm');
    await _scrollTo(tester, story, EasternSystemsScreen);
    await tester.tap(story);
    await pumpUntilFound(tester, find.byType(StoryEpisodeScreen));
    await settleScreen(tester);

    expect(find.textContaining('Tám đoạn gấm là một cái tên'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsNothing);
    expect(find.text(_disclaimer), findsOneWidget);
    await app.dispose();
  });
}
