import 'dart:convert';
import 'dart:io';

const manifestPath = 'catalog/catalog.v1.json';

String readManifest() => File(manifestPath).readAsStringSync();

/// Returns a mutable copy of the real manifest for negative tests.
Map<String, Object?> manifestJson() =>
    jsonDecode(readManifest()) as Map<String, Object?>;

List<Map<String, Object?>> listOf(Map<String, Object?> json, String key) =>
    (json[key]! as List<Object?>).cast<Map<String, Object?>>();

/// The real manifest is published; this variant is unreviewed demo content,
/// used to test the publication gate and the DEMO labels.
Map<String, Object?> draftManifestJson() {
  final json = manifestJson();
  json['status'] = 'draft';
  json['demoOnly'] = true;
  json['catalogVersion'] = draftCatalogVersion;
  for (final key in ['exercises', 'routines', 'mediaAssets']) {
    for (final item in listOf(json, key)) {
      item['reviewStatus'] = 'draft';
      item['demoOnly'] = true;
    }
  }
  return json;
}

const draftCatalogVersion = '2026.10.18-draft.1';

String draftManifest() => jsonEncode(draftManifestJson());
