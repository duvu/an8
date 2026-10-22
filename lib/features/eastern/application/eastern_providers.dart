import 'package:an_nhien_eastern_content/an_nhien_eastern_content.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../catalog/application/catalog_providers.dart';
import '../data/eastern_systems_repository.dart';
import '../domain/practice_system.dart';

final easternSystemsRepositoryProvider = Provider<EasternSystemsRepository>(
  (ref) => EasternSystemsRepository(
    EasternContentRepository(bundle: ref.watch(assetBundleProvider)),
  ),
);

/// Introductions are shown in every build (D09); they never become workouts here.
final easternSystemsProvider = FutureProvider<List<PracticeSystem>>(
  (ref) => ref.watch(easternSystemsRepositoryProvider).getSystems(),
);
