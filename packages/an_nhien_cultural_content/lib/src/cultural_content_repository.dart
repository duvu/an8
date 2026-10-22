import 'dart:convert';
import 'package:flutter/services.dart' show AssetBundle, rootBundle;

/// Read-only locale-specific editorial content. Never implies clinical or exercise approval.
class CulturalContentRepository {
  CulturalContentRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;
  final AssetBundle _bundle;
  static const _prefix = 'packages/an_nhien_cultural_content/';

  Future<Map<String, dynamic>> _readJson(String asset) async {
    final text = await _bundle.loadString('$_prefix$asset');
    return jsonDecode(text) as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getSystems() async {
    final json = await _readJson('assets/catalog/systems.vi.v1.json');
    return List<Map<String, dynamic>>.from(json['systems'] as List);
  }

  Future<List<Map<String, dynamic>>> getStories() async {
    final json = await _readJson('assets/catalog/exercise_stories.vi.v1.json');
    return List<Map<String, dynamic>>.from(json['exercises'] as List);
  }

  Future<Map<String, dynamic>?> getStoryByExerciseId(String id) async {
    for (final story in await getStories()) {
      if (story['exerciseId'] == id) return story;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getEpisodes() async {
    final json = await _readJson('assets/catalog/speaker_episodes.vi.v1.json');
    return List<Map<String, dynamic>>.from(json['episodes'] as List);
  }

  Future<String> loadScript(String relativePath) =>
      _bundle.loadString('$_prefix$relativePath');
}
