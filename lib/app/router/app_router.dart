import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/downloads/presentation/downloads_screen.dart';
import '../../features/eastern/presentation/eastern_form_screen.dart';
import '../../features/eastern/presentation/eastern_overview_screen.dart';
import '../../features/eastern/presentation/eastern_system_detail_screen.dart';
import '../../features/eastern/presentation/eastern_systems_screen.dart';
import '../../features/learn/presentation/exercise_learn_screen.dart';
import '../../features/learn/presentation/story_episode_screen.dart';
import '../../features/health/domain/health_metric.dart';
import '../../features/health/presentation/add_measurement_screen.dart';
import '../../features/health/presentation/health_export_screen.dart';
import '../../features/health/presentation/health_metric_screen.dart';
import '../../features/health/presentation/health_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/library/presentation/library_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/routine/presentation/preflight_screen.dart';
import '../../features/routine/presentation/routine_detail_screen.dart';
import '../../features/safety/presentation/safety_screen.dart';
import '../../features/session/presentation/session_player_screen.dart';
import '../../features/session/presentation/session_summary_screen.dart';
import '../../features/settings/application/preferences_controller.dart';
import '../../features/splash/application/splash_providers.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../localization/generated/app_localizations.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: ref.read(splashEnabledProvider)
        ? AppRoutes.splash
        : AppRoutes.home,
    redirect: (_, state) {
      if (state.matchedLocation == AppRoutes.splash) return null;
      final onboarded = ref.read(preferencesProvider).onboardingCompleted;
      final atOnboarding = state.matchedLocation == AppRoutes.onboarding;
      if (!onboarded && !atOnboarding) return AppRoutes.onboarding;
      return null;
    },
    routes: [
      // Bottom navigation only on browse screens, never while practising.
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => _BrowseShell(shell: shell),
        branches: [
          for (final (path, screen) in [
            (AppRoutes.home, const HomeScreen()),
            (AppRoutes.library, const LibraryScreen()),
            (AppRoutes.health, const HealthScreen()),
            (AppRoutes.progress, const HistoryScreen()),
            (AppRoutes.settings, const SettingsScreen()),
          ])
            StatefulShellBranch(
              routes: [GoRoute(path: path, builder: (_, _) => screen)],
            ),
        ],
      ),
      GoRoute(
        path: AppRoutes.calendar,
        builder: (_, _) => const CalendarScreen(),
      ),
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingScreen(),
      ),
      GoRoute(path: AppRoutes.safety, builder: (_, _) => const SafetyScreen()),
      GoRoute(
        path: AppRoutes.eastern,
        builder: (_, _) => const EasternSystemsScreen(),
        routes: [
          GoRoute(
            path: ':slug',
            builder: (_, state) =>
                EasternSystemDetailScreen(slug: state.pathParameters['slug']!),
            routes: [
              GoRoute(
                path: 'form/:exerciseId',
                builder: (_, state) => EasternFormScreen(
                  slug: state.pathParameters['slug']!,
                  exerciseId: state.pathParameters['exerciseId']!,
                ),
              ),
              GoRoute(
                path: 'overview/:boardId',
                builder: (_, state) => EasternOverviewScreen(
                  slug: state.pathParameters['slug']!,
                  boardId: state.pathParameters['boardId']!,
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/health-metric/:metric',
        builder: (_, state) =>
            HealthMetricScreen(metricName: state.pathParameters['metric']!),
      ),
      GoRoute(
        path: AppRoutes.healthExport,
        builder: (_, _) => const HealthExportScreen(),
      ),
      GoRoute(
        path: '/health-add',
        builder: (_, state) => AddMeasurementScreen(
          initialMetric: HealthMetric.values
              .asNameMap()[state.uri.queryParameters['metric']],
        ),
      ),
      GoRoute(
        path: '/learn/exercise/:id',
        builder: (_, state) =>
            ExerciseLearnScreen(exerciseId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/learn/story/:id',
        builder: (_, state) =>
            StoryEpisodeScreen(episodeId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.downloads,
        builder: (_, _) => const DownloadsScreen(),
      ),
      GoRoute(
        path: '/routine/:id',
        builder: (_, state) =>
            RoutineDetailScreen(routineId: state.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'preflight',
            builder: (_, state) =>
                PreflightScreen(routineId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: '/session/:routineId',
        builder: (_, state) =>
            SessionPlayerScreen(routineId: state.pathParameters['routineId']!),
      ),
      GoRoute(
        path: '/summary/:sessionId',
        builder: (_, state) =>
            SessionSummaryScreen(sessionId: state.pathParameters['sessionId']!),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

class _BrowseShell extends StatelessWidget {
  const _BrowseShell({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.grid_view),
            label: l10n.navLibrary,
          ),
          NavigationDestination(
            icon: const Icon(Icons.monitor_heart_outlined),
            label: l10n.navHealth,
          ),
          NavigationDestination(
            icon: const Icon(Icons.insights_outlined),
            label: l10n.navProgress,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
