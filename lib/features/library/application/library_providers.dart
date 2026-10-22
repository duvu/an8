import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../catalog/application/catalog_providers.dart';
import '../../catalog/domain/catalog_models.dart';
import '../domain/library_filter.dart';

class LibraryFilterController extends Notifier<LibraryFilter> {
  @override
  LibraryFilter build() => const LibraryFilter();

  void update(LibraryFilter Function(LibraryFilter) change) =>
      state = change(state);

  void clear() => state = const LibraryFilter();
}

final libraryFilterProvider =
    NotifierProvider<LibraryFilterController, LibraryFilter>(
      LibraryFilterController.new,
    );

final class LibraryData {
  const LibraryData({
    required this.catalog,
    required this.results,
    required this.tags,
    required this.available,
  });

  final ContentCatalog catalog;
  final List<Routine> results;

  /// Tags present in the catalog, in first-seen order (data-driven goal filter).
  final List<String> tags;
  final Set<String> available;

  bool isAvailable(Routine r) =>
      available.containsAll(catalog.requiredFilesOf(r));
}

final libraryDataProvider = FutureProvider<LibraryData>((ref) async {
  final catalog = await ref.watch(catalogProvider.future);
  final available = await ref.watch(availableMediaProvider.future);
  final filter = ref.watch(libraryFilterProvider);
  bool isAvailable(Routine r) =>
      available.containsAll(catalog.requiredFilesOf(r));
  return LibraryData(
    catalog: catalog,
    results: filter.apply(catalog, isAvailable: isAvailable),
    tags: {for (final r in catalog.routines) ...r.tags}.toList(),
    available: available,
  );
});
