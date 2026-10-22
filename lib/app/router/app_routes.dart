abstract final class AppRoutes {
  static const splash = '/splash';
  static const home = '/';
  static const library = '/library';
  static const progress = '/progress';
  static const settings = '/settings';
  static const onboarding = '/onboarding';
  static const safety = '/safety';
  static const downloads = '/downloads';
  static const eastern = '/eastern';
  static const health = '/health';
  static const calendar = '/calendar';
  static const healthExport = '/health-export';

  static String routine(String id) => '/routine/$id';
  static String preflight(String id) => '/routine/$id/preflight';
  static String session(String routineId) => '/session/$routineId';
  static String summary(String sessionId) => '/summary/$sessionId';
  static String easternSystem(String slug) => '/eastern/$slug';
  static String healthMetric(String metric) => '/health-metric/$metric';

  /// Optional [metric] preselects what is being logged.
  static String healthAdd([String? metric]) =>
      metric == null ? '/health-add' : '/health-add?metric=$metric';
  static String exerciseLearn(String exerciseId) =>
      '/learn/exercise/$exerciseId';
  static String storyEpisode(String id) => '/learn/story/$id';
  static String easternForm(String slug, String exerciseId) =>
      '/eastern/$slug/form/$exerciseId';
  static String easternOverview(String slug, String boardId) =>
      '/eastern/$slug/overview/$boardId';
}
