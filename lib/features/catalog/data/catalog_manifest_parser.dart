import 'dart:convert';

import '../domain/catalog_models.dart';

/// Thrown when a manifest violates schema v1 or its referential rules.
final class CatalogFormatException implements Exception {
  const CatalogFormatException(this.issues);

  final List<String> issues;

  @override
  String toString() => 'CatalogFormatException:\n${issues.join('\n')}';
}

/// Parses and validates a schema-v1 manifest (mirrors scripts/validate_catalog.py
/// for structure and references; file hashes are checked at build time and by downloads).
final class CatalogManifestParser {
  const CatalogManifestParser();

  static const supportedSchemaVersion = 1;

  ContentCatalog parse(String source) {
    final Object? decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException catch (e) {
      throw CatalogFormatException(['invalid JSON: ${e.message}']);
    }
    final reader = _Reader(decoded, r'$');
    final catalog = _parseCatalog(reader);
    final issues = [
      ...reader.issues,
      if (catalog != null) ..._checkReferences(catalog),
    ];
    if (issues.isNotEmpty || catalog == null) {
      throw CatalogFormatException(issues);
    }
    return catalog;
  }

  ContentCatalog? _parseCatalog(_Reader r) {
    final schemaVersion = r.integer('schemaVersion');
    if (schemaVersion != null && schemaVersion != supportedSchemaVersion) {
      r.issue('schemaVersion', 'unsupported $schemaVersion');
    }
    final catalog = ContentCatalog(
      catalogId: r.string('catalogId'),
      catalogVersion: r.string('catalogVersion'),
      locale: r.string('locale'),
      demoOnly: r.boolean('demoOnly'),
      exercises: r.list('exercises', _parseExercise),
      routines: r.list('routines', _parseRoutine),
      mediaAssets: r.list('mediaAssets', _parseMedia),
    );
    return r.issues.isEmpty ? catalog : null;
  }

  Exercise _parseExercise(_Reader r) => Exercise(
    id: r.string('id', pattern: RegExp(r'^E[0-9]{2,}$')),
    version: r.integer('version', min: 1) ?? 0,
    locale: r.string('locale'),
    title: r.string('title'),
    defaultDuration: Duration(
      seconds: r.integer('defaultDurationSeconds', min: 1) ?? 0,
    ),
    position: r.enumValue('position', BodyPosition.values),
    intensity: r.enumValue('intensity', Intensity.values),
    tags: r.strings('tags'),
    reviewStatus: r.reviewStatus(),
    demoOnly: r.boolean('demoOnly'),
    safetyNotes: r.strings('safetyNotes', minItems: 1),
    steps: r.list(
      'steps',
      (s) => ExerciseStep(
        order: s.integer('order', min: 1) ?? 0,
        instruction: s.string('instruction'),
        framePath: s.string('framePath'),
      ),
    ),
    posterMediaId: r.string('posterMediaId'),
    mediaAssetIds: r.strings('mediaAssetIds', minItems: 1),
  );

  Routine _parseRoutine(_Reader r) {
    final routine = Routine(
      id: r.string('id', pattern: RegExp(r'^R[0-9]{2,}$')),
      version: r.integer('version', min: 1) ?? 0,
      locale: r.string('locale'),
      title: r.string('title'),
      description: r.string('description'),
      tags: r.strings('tags'),
      reviewStatus: r.reviewStatus(),
      demoOnly: r.boolean('demoOnly'),
      steps: r.list(
        'steps',
        (s) => RoutineStep(
          order: s.integer('order', min: 1) ?? 0,
          exerciseId: s.string('exerciseId'),
          exerciseVersion: s.integer('exerciseVersion', min: 1) ?? 0,
          duration: Duration(
            seconds: s.integer('durationSeconds', min: 1) ?? 0,
          ),
          mediaVariant: s.enumValue('mediaVariant', MediaVariant.values),
        ),
      ),
    );
    final declared = r.integer('totalDurationSeconds', min: 1);
    if (declared != null && declared != routine.totalDuration.inSeconds) {
      r.issue(
        'totalDurationSeconds',
        '$declared != sum of steps ${routine.totalDuration.inSeconds}',
      );
    }
    return routine;
  }

  MediaAsset _parseMedia(_Reader r) => MediaAsset(
    id: r.string('id'),
    version: r.integer('version', min: 1) ?? 0,
    kind: r.enumValue('kind', MediaKind.values),
    locale: r.string('locale'),
    files: r.list(
      'files',
      (f) => MediaFile(
        path: f.string('path'),
        bytes: f.integer('bytes', min: 0) ?? 0,
        sha256: f.string('sha256', pattern: RegExp(r'^[a-fA-F0-9]{64}$')),
      ),
    ),
    reviewStatus: r.reviewStatus(),
    demoOnly: r.boolean('demoOnly'),
    aiGenerated: r.boolean('aiGenerated'),
    rights: r.string('rights'),
    accessibilityDescription: r.string('accessibilityDescription'),
  );

  List<String> _checkReferences(ContentCatalog c) {
    final issues = <String>[];
    void unique(String kind, Iterable<String> keys) {
      final seen = <String>{};
      for (final key in keys) {
        if (!seen.add(key)) issues.add('duplicate $kind $key');
      }
    }

    unique('exercise', c.exercises.map((e) => '${e.id}@${e.version}'));
    unique('routine', c.routines.map((r) => '${r.id}@${r.version}'));
    unique('media', c.mediaAssets.map((m) => m.id));

    for (final e in c.exercises) {
      for (final id in {e.posterMediaId, ...e.mediaAssetIds}) {
        if (c.media(id) == null) issues.add('${e.id}: unknown media $id');
      }
      _checkOrder('${e.id}.steps', e.steps.map((s) => s.order), issues);
    }
    for (final r in c.routines) {
      for (final s in r.steps) {
        if (c.exercise(s.exerciseId, s.exerciseVersion) == null) {
          issues.add(
            '${r.id}: unknown exercise ${s.exerciseId}@${s.exerciseVersion}',
          );
        }
      }
      _checkOrder('${r.id}.steps', r.steps.map((s) => s.order), issues);
    }
    return issues;
  }

  void _checkOrder(String where, Iterable<int> orders, List<String> issues) {
    var expected = 1;
    for (final order in orders) {
      if (order != expected++) {
        issues.add('$where: order must be 1..n without gaps');
        return;
      }
    }
  }
}

/// Typed JSON reader that collects issues with JSON paths instead of failing fast.
final class _Reader {
  _Reader(this._value, this._path, [List<String>? issues])
    : issues = issues ?? <String>[];

  final Object? _value;
  final String _path;
  final List<String> issues;

  void issue(String key, String message) => issues.add('$_path.$key: $message');

  Object? _field(String key) {
    final value = _value;
    if (value is Map<String, Object?>) return value[key];
    issues.add('$_path: expected object');
    return null;
  }

  String string(String key, {RegExp? pattern}) {
    final value = _field(key);
    if (value is! String || value.isEmpty) {
      issue(key, 'expected non-empty string');
      return '';
    }
    if (pattern != null && !pattern.hasMatch(value)) {
      issue(key, '"$value" does not match ${pattern.pattern}');
    }
    return value;
  }

  int? integer(String key, {int? min}) {
    final value = _field(key);
    if (value is! int) {
      issue(key, 'expected integer');
      return null;
    }
    if (min != null && value < min) issue(key, 'must be >= $min');
    return value;
  }

  bool boolean(String key) {
    final value = _field(key);
    if (value is bool) return value;
    issue(key, 'expected boolean');
    return false;
  }

  List<String> strings(String key, {int minItems = 0}) {
    final value = _field(key);
    if (value is! List<Object?> ||
        value.length < minItems ||
        value.any((v) => v is! String || v.isEmpty)) {
      issue(key, 'expected list of >= $minItems non-empty strings');
      return const [];
    }
    return List.unmodifiable(value.cast<String>());
  }

  List<T> list<T>(String key, T Function(_Reader) parse) {
    final value = _field(key);
    if (value is! List<Object?> || value.isEmpty) {
      issue(key, 'expected non-empty list');
      return const [];
    }
    return List.unmodifiable([
      for (var i = 0; i < value.length; i++)
        parse(_Reader(value[i], '$_path.$key[$i]', issues)),
    ]);
  }

  /// Maps camelCase enum names to the manifest's snake_case values.
  T enumValue<T extends Enum>(String key, List<T> values) {
    final raw = _field(key);
    for (final v in values) {
      if (_snake(v.name) == raw) return v;
    }
    issue(key, 'unknown value "$raw"');
    return values.first;
  }

  ReviewStatus reviewStatus() => enumValue('reviewStatus', ReviewStatus.values);

  static String _snake(String camel) =>
      camel.replaceAllMapped(RegExp('[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');
}
