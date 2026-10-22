import 'package:an_nhien_eastern_content/an_nhien_eastern_content.dart';

import '../domain/practice_system.dart';

/// Reads the eastern content pack (packages/an_nhien_eastern_content) into typed
/// models. Only introduction metadata is used; draft exercises are never played.
final class EasternSystemsRepository {
  EasternSystemsRepository(this._content);

  final EasternContentRepository _content;

  Future<List<PracticeSystem>> getSystems() async {
    final index = await _content.getSystemIndex();
    final entries = _list(index, 'practiceSystems', r'$index');
    final illustrations = await _formSpecificCards();
    final boards = await _overviewBoards();
    return [
      for (final (i, entry) in entries.indexed)
        await _system(
          _map(entry, 'index.practiceSystems[$i]'),
          illustrations,
          boards,
        ),
    ];
  }

  /// routineId -> its overview boards (v9 Tai Chi 24 pack).
  Future<Map<String, List<OverviewBoard>>> _overviewBoards() async {
    const where = 'taichi24_overview';
    final overview = await _content.getTaichi24Overview();
    return {
      _string(overview, 'routineId', where): [
        for (final (i, raw) in _list(overview, 'pages', where).indexed)
          _board(_map(raw, '$where.pages[$i]'), '$where.pages[$i]'),
      ],
    };
  }

  OverviewBoard _board(Map<String, Object?> page, String where) {
    final asset = _string(page, 'asset', where);
    return OverviewBoard(
      id: _string(page, 'id', where),
      title: _string(page, 'title', where),
      // The pack writes full keys here, unlike the relative paths elsewhere.
      assetKey: asset.startsWith(EasternContentRepository.assetPrefix)
          ? asset
          : _content.imageKey(asset),
    );
  }

  /// exerciseId -> asset key, only for cards flagged as specific to that form.
  Future<Map<String, String>> _formSpecificCards() async {
    const where = 'listing_media';
    final manifest = await _content.getListingMediaManifest();
    final cards = <String, String>{};
    for (final (i, raw) in _list(manifest, 'exercises', where).indexed) {
      final card = _map(raw, '$where[$i]');
      if (card['coverIsExerciseSpecific'] != true) continue;
      cards[_string(card, 'id', '$where[$i]')] = _content.imageKey(
        _string(card, 'coverPath', '$where[$i]'),
      );
    }
    return cards;
  }

  Future<PracticeSystem> _system(
    Map<String, Object?> entry,
    Map<String, String> illustrations,
    Map<String, List<OverviewBoard>> boards,
  ) async {
    final slug = _string(entry, 'slug', 'index');
    final where = '$slug sidecar';
    final s = await _content.getSystem(slug);
    final researchOnly = s['status'] == 'research_only';
    final forms = _list(s, 'exerciseTitles', where);
    final formCount = _int(s, 'numberOfForms', where);
    final routineIds = _strings(s['routineIds'] ?? const <Object?>[], where);
    if (forms.length != formCount) {
      throw FormatException(
        '$where: numberOfForms $formCount != ${forms.length} forms',
      );
    }
    return PracticeSystem(
      slug: slug,
      titleVi: _string(s, 'titleVi', where),
      titleOriginal: _string(s, 'titleEn', where),
      formCount: formCount,
      coverAssetKey: _content.imageKey(_string(s, 'coverPath', where)),
      researchOnly: researchOnly,
      summary: s['summary'] as String?,
      level: s['level'] as String?,
      notes: (s['lineageNotes'] ?? s['reason']) as String?,
      forms: [
        for (final (i, f) in forms.indexed)
          _form(
            _map(f, '$where.exerciseTitles[$i]'),
            '$where.exerciseTitles[$i]',
            illustrations,
          ),
      ],
      safetyNotes: _strings(s['safetyPolicy'] ?? s['safetyNotes'], where),
      sources: _strings(s['sourceReferences'] ?? const <Object?>[], where),
      routineIds: routineIds,
      overviewBoards: [for (final id in routineIds) ...?boards[id]],
      requiredBeforeAuthoring: _strings(
        s['requiredBeforeAuthoring'] ?? const <Object?>[],
        where,
      ),
    );
  }

  PracticeForm _form(
    Map<String, Object?> f,
    String where,
    Map<String, String> illustrations,
  ) {
    final id = _string(f, 'exerciseId', where);
    return PracticeForm(
      exerciseId: id,
      number: _int(f, 'number', where),
      titleVi: _string(f, 'titleVi', where),
      originalName: _string(f, 'sourceNameEn', where),
      illustrationKey: illustrations[id],
    );
  }

  static Map<String, Object?> _map(Object? value, String where) {
    if (value is Map<String, Object?>) return value;
    throw FormatException('$where: expected object');
  }

  static List<Object?> _list(Map<String, Object?> m, String key, String where) {
    final value = m[key];
    if (value is List<Object?>) return value;
    throw FormatException('$where.$key: expected list');
  }

  static String _string(Map<String, Object?> m, String key, String where) {
    final value = m[key];
    if (value is String && value.isNotEmpty) return value;
    throw FormatException('$where.$key: expected non-empty string');
  }

  static int _int(Map<String, Object?> m, String key, String where) {
    final value = m[key];
    if (value is int && value >= 0) return value;
    throw FormatException('$where.$key: expected non-negative integer');
  }

  static List<String> _strings(Object? value, String where) {
    if (value is List<Object?> && value.every((v) => v is String)) {
      return value.cast<String>();
    }
    throw FormatException('$where: expected list of strings');
  }
}
