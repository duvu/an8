import '../domain/catalog_models.dart';
import '../domain/content_visibility.dart';
import 'catalog_data_source.dart';
import 'catalog_manifest_parser.dart';

/// Single source of content for the app (05_Content_Catalog_And_Series.md contract).
abstract interface class ContentCatalogRepository {
  /// [forceRefresh] re-reads the source; in the MVP that is a local reload, never network.
  Future<ContentCatalog> getCatalog({bool forceRefresh = false});
  Future<Exercise?> getExercise(String id, int version);
  Future<Routine?> getRoutine(String id);
}

final class DefaultContentCatalogRepository
    implements ContentCatalogRepository {
  DefaultContentCatalogRepository({
    required this._dataSource,
    required this._visibility,
    this._parser = const CatalogManifestParser(),
  });

  final CatalogDataSource _dataSource;
  final ContentVisibility _visibility;
  final CatalogManifestParser _parser;
  ContentCatalog? _cached;

  @override
  Future<ContentCatalog> getCatalog({bool forceRefresh = false}) async {
    final cached = _cached;
    if (!forceRefresh && cached != null) return cached;
    return _cached = await _load();
  }

  Future<ContentCatalog> _load() async =>
      _visibility.apply(_parser.parse(await _dataSource.readManifest()));

  @override
  Future<Exercise?> getExercise(String id, int version) async =>
      (await getCatalog()).exercise(id, version);

  @override
  Future<Routine?> getRoutine(String id) async =>
      (await getCatalog()).routine(id);
}
