import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../catalog/application/catalog_providers.dart';
import '../../catalog/domain/catalog_models.dart';
import '../../settings/application/preferences_controller.dart';

final class HomeData {
  const HomeData({
    required this.catalog,
    this.featured,
    this.others = const [],
  });

  final ContentCatalog catalog;
  final Routine? featured;
  final List<Routine> others;
}

final homeDataProvider = FutureProvider<HomeData>((ref) async {
  final catalog = await ref.watch(catalogProvider.future);
  final prefs = ref.watch(preferencesProvider);
  final routines = catalog.routines;
  if (routines.isEmpty) return HomeData(catalog: catalog);
  // Preferences rank suggestions; they never hide other routines (PRD F01).
  int score(Routine r) =>
      (prefs.position != null && catalog.positionOf(r) == prefs.position
          ? 1
          : 0) +
      (prefs.goalTag != null && r.tags.contains(prefs.goalTag) ? 1 : 0);
  final featured = routines.reduce(
    (best, r) => score(r) > score(best) ? r : best,
  );
  return HomeData(
    catalog: catalog,
    featured: featured,
    others: [
      for (final r in routines)
        if (r != featured) r,
    ],
  );
});
