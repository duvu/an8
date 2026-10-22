import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/config/app_config.dart';
import '../data/catalog_data_source.dart';
import '../data/content_catalog_repository.dart';
import '../data/media_availability.dart';
import '../domain/catalog_models.dart';
import '../domain/content_visibility.dart';

final assetBundleProvider = Provider<AssetBundle>((ref) => rootBundle);

final contentVisibilityProvider = Provider<ContentVisibility>(
  (ref) => const ContentVisibility(
    allowPreviewContent: AppConfig.allowPreviewContent,
  ),
);

final catalogRepositoryProvider = Provider<ContentCatalogRepository>(
  (ref) => DefaultContentCatalogRepository(
    dataSource: BundledCatalogDataSource(ref.watch(assetBundleProvider)),
    visibility: ref.watch(contentVisibilityProvider),
  ),
);

final catalogProvider = FutureProvider<ContentCatalog>(
  (ref) => ref.watch(catalogRepositoryProvider).getCatalog(),
);

final mediaAvailabilityProvider = Provider<MediaAvailability>(
  (ref) => BundledMediaAvailability(ref.watch(assetBundleProvider)),
);

final availableMediaProvider = FutureProvider<Set<String>>(
  (ref) => ref.watch(mediaAvailabilityProvider).availablePaths(),
);

/// Whether every file the player needs for [routineId] is on the device.
final routineAvailableProvider = FutureProvider.family<bool, String>((
  ref,
  routineId,
) async {
  final catalog = await ref.watch(catalogProvider.future);
  final routine = catalog.routine(routineId);
  if (routine == null) return false;
  final available = await ref.watch(availableMediaProvider.future);
  return available.containsAll(catalog.requiredFilesOf(routine));
});
