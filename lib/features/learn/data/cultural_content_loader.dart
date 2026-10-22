import 'dart:convert';

import 'package:an_nhien_cultural_content/an_nhien_cultural_content.dart';

import '../domain/cultural_content.dart';

/// Maps the cultural package's JSON into typed models; malformed entries
/// throw [FormatException] instead of rendering half a story.
final class CulturalContentLoader {
  const CulturalContentLoader(this._package);

  final CulturalContentRepository _package;

  static const _referencesPath = 'assets/sources/references.vi.v1.json';

  /// The pack fills `historicalNote` of every eastern form with a pointer
  /// ("… xem tại baduanjin.") to the system profile, which the system
  /// screen already shows.
  static final _pointerNote = RegExp(r'xem tại [a-z0-9]+\.?$');

  Future<CulturalContent> load() async {
    final references = jsonDecode(await _package.loadScript(_referencesPath));
    return CulturalContent(
      stories: [for (final j in await _package.getStories()) _story(j)],
      profiles: [for (final j in await _package.getSystems()) _profile(j)],
      episodes: [for (final j in await _package.getEpisodes()) _episode(j)],
      references: [
        for (final j in (references as Map<String, dynamic>)['items'] as List)
          _reference(j as Map<String, dynamic>),
      ],
    );
  }

  Future<String> script(StoryEpisode episode) =>
      _package.loadScript(episode.scriptPath);

  ExerciseStory _story(Map<String, dynamic> j) {
    final note = _string(j, 'historicalNote');
    return ExerciseStory(
      exerciseId: _string(j, 'exerciseId'),
      title: _string(j, 'title'),
      angle: _string(j, 'culturalAngle'),
      meaning: _string(j, 'meaning'),
      movementAwareness: _string(j, 'movementAwareness'),
      historicalNote: _pointerNote.hasMatch(note) ? null : note,
      sourceIds: _strings(j, 'sourceIds'),
    );
  }

  SystemProfile _profile(Map<String, dynamic> j) => SystemProfile(
    id: _string(j, 'id'),
    originLabel: _string(j, 'originLabel'),
    history: _string(j, 'history'),
    culturalContext: _string(j, 'culturalContext'),
    interpretiveFrame: _string(j, 'interpretiveFrame'),
    cautions: _strings(j, 'cautions'),
    sourceIds: _strings(j, 'sourceIds'),
  );

  StoryEpisode _episode(Map<String, dynamic> j) => StoryEpisode(
    id: _string(j, 'id'),
    title: _string(j, 'title'),
    scriptPath: _string(j, 'scriptAssetPath'),
  );

  Reference _reference(Map<String, dynamic> j) => Reference(
    id: _string(j, 'id'),
    title: _string(j, 'title'),
    url: _string(j, 'url'),
  );

  static String _string(Map<String, dynamic> j, String key) => switch (j[key]) {
    final String value when value.trim().isNotEmpty => value.trim(),
    _ => throw FormatException('Cultural content: missing "$key"', j),
  };

  static List<String> _strings(Map<String, dynamic> j, String key) =>
      switch (j[key]) {
        final List<dynamic> list => list.cast<String>(),
        _ => throw FormatException('Cultural content: missing "$key"', j),
      };
}
