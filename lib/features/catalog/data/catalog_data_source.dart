import 'package:flutter/services.dart';

/// Source of the raw catalog manifest. A remote/CMS source can be added later
/// without touching the repository, domain or UI.
abstract interface class CatalogDataSource {
  Future<String> readManifest();
}

final class BundledCatalogDataSource implements CatalogDataSource {
  const BundledCatalogDataSource(this._bundle, {this.assetPath = defaultPath});

  static const defaultPath = 'catalog/catalog.v1.json';

  final AssetBundle _bundle;
  final String assetPath;

  @override
  Future<String> readManifest() => _bundle.loadString(assetPath, cache: false);
}
