import 'dart:convert';
import 'package:flutter/services.dart';

/// Loads self-contained v1-compatible drafts from Flutter package assets.
/// Never promotes drafts to published content. CMS adapter may replace the source.
final class EasternContentRepository {
  EasternContentRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;
  final AssetBundle _bundle;

  static const String packageName = 'an_nhien_eastern_content';
  static const String assetPrefix = 'packages/$packageName/';

  String imageKey(String relativePath) => '$assetPrefix$relativePath';

  Future<Map<String, dynamic>> _jsonAsset(String path) async {
    final raw = await _bundle.loadString('$assetPrefix$path');
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw FormatException('Expected JSON object at $path');
    }
    return decoded;
  }

  Future<Map<String, dynamic>> getSystemIndex() =>
      _jsonAsset('assets/catalog/index.v1.json');

  Future<Map<String, dynamic>> getSystem(String slug) =>
      _jsonAsset('assets/catalog/${slug == 'xisuijing' ? 'xisuijing.research.v1' : '$slug.system.v1'}.json');

  /// Includes DRAFT catalogs so an internal authoring screen can preview them.
  /// Never use this directly for public practice recommendations.
  Future<Map<String, dynamic>> getDraftCatalog(String slug) {
    if (slug == 'xisuijing') {
      throw StateError('Xi Sui Jing has no defined instructional sequence');
    }
    const valid = {'baduanjin','yijinjing','wuqinxi','liuzijue','taichi24'};
    if (!valid.contains(slug)) throw ArgumentError.value(slug, 'slug');
    return _jsonAsset('assets/catalog/$slug.draft.v1.json');
  }

  /// Merge with an existing v1.1 catalog only for internal, clearly marked DEMO.
  /// Collision detection, routine-step reference checks and versioned IDs are mandatory.
  Future<Map<String, dynamic>> mergeForDeveloperPreview(
    Map<String, dynamic> base, {
    List<String> slugs = const ['baduanjin','yijinjing','wuqinxi','liuzijue','taichi24'],
  }) async {
    if (base['schemaVersion'] != 1) {
      throw FormatException('Requires An Nhien catalog schemaVersion=1');
    }
    final output = <String, dynamic>{...base, 'status':'draft', 'demoOnly':true};
    for (final collection in ['exercises','routines','mediaAssets']) {
      output[collection] = List<dynamic>.from(base[collection] as List);
    }
    for (final slug in slugs) {
      final other = await getDraftCatalog(slug);
      for (final collection in ['exercises','routines','mediaAssets']) {
        final dest = output[collection] as List<dynamic>;
        final incoming = other[collection] as List;
        final existingIds = dest.map((entry) => (entry as Map)['id']).toSet();
        for (final entry in incoming) {
          final id = (entry as Map)['id'];
          if (existingIds.contains(id)) {
            throw StateError('Duplicate $collection ID: $id');
          }
          existingIds.add(id);
          dest.add(entry);
        }
      }
    }
    final exerciseKeys = (output['exercises'] as List)
        .map((e) => '${(e as Map)['id']}@${e['version']}').toSet();
    final mediaIds = (output['mediaAssets'] as List)
        .map((e) => (e as Map)['id']).toSet();
    for (final routine in output['routines'] as List) {
      for (final step in (routine as Map)['steps'] as List) {
        if (!exerciseKeys.contains('${step['exerciseId']}@${step['exerciseVersion']}')) {
          throw FormatException('Unresolved routine step: ${step['exerciseId']}');
        }
      }
    }
    for (final ex in output['exercises'] as List) {
      if (!mediaIds.contains((ex as Map)['posterMediaId'])) {
        throw FormatException('Unresolved media: ${ex['posterMediaId']}');
      }
    }
    return output;
  }

  /// No draft exercise may appear in public playback. This filter is defensive;
  /// publication additionally requires recorded expert approval and verified media.
  static List<Map<String, dynamic>> visiblePublishedRoutines(
      Map<String, dynamic> catalog) {
    if (catalog['status'] != 'published' || catalog['demoOnly'] != false) {
      return const [];
    }
    final approvedExercises = <String, Map>{};
    for (final ex in catalog['exercises'] as List) {
      if (ex['reviewStatus'] == 'approved' && ex['demoOnly'] == false) {
        approvedExercises['${ex['id']}@${ex['version']}'] = ex as Map;
      }
    }
    final approvedMedia = <String>{};
    for (final media in catalog['mediaAssets'] as List) {
      if (media['reviewStatus'] == 'approved' && media['demoOnly'] == false) {
        approvedMedia.add(media['id'] as String);
      }
    }
    return (catalog['routines'] as List)
        .where((routine) {
          if (routine['reviewStatus'] != 'approved' || routine['demoOnly'] != false) {
            return false;
          }
          return (routine['steps'] as List).every((step) {
            final key = '${step['exerciseId']}@${step['exerciseVersion']}';
            final ex = approvedExercises[key];
            return ex != null &&
                (ex['mediaAssetIds'] as List).every((id) => approvedMedia.contains(id));
          });
        })
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList(growable: false);
  }
}
