import '../../catalog/domain/catalog_models.dart';

enum DurationBucket {
  short(max: Duration(minutes: 6)),
  medium(max: Duration(minutes: 10)),
  long();

  const DurationBucket({this.max});

  /// Inclusive upper bound; null = unbounded.
  final Duration? max;

  static DurationBucket of(Duration d) =>
      values.firstWhere((b) => b.max == null || d <= b.max!);
}

final class LibraryFilter {
  const LibraryFilter({
    this.query = '',
    this.tag,
    this.position,
    this.duration,
    this.offlineOnly = false,
  });

  final String query;
  final String? tag;
  final BodyPosition? position;
  final DurationBucket? duration;
  final bool offlineOnly;

  bool get isEmpty =>
      query.trim().isEmpty &&
      tag == null &&
      position == null &&
      duration == null &&
      !offlineOnly;

  LibraryFilter copyWith({
    String? query,
    String? Function()? tag,
    BodyPosition? Function()? position,
    DurationBucket? Function()? duration,
    bool? offlineOnly,
  }) => LibraryFilter(
    query: query ?? this.query,
    tag: tag != null ? tag() : this.tag,
    position: position != null ? position() : this.position,
    duration: duration != null ? duration() : this.duration,
    offlineOnly: offlineOnly ?? this.offlineOnly,
  );

  List<Routine> apply(
    ContentCatalog catalog, {
    required bool Function(Routine) isAvailable,
  }) {
    final q = _fold(query.trim());
    return [
      for (final r in catalog.routines)
        if ((q.isEmpty ||
                _fold(r.title).contains(q) ||
                r.steps.any(
                  (s) => _fold(catalog.exerciseFor(s).title).contains(q),
                )) &&
            (tag == null || r.tags.contains(tag)) &&
            (position == null || catalog.positionOf(r) == position) &&
            (duration == null ||
                DurationBucket.of(r.totalDuration) == duration) &&
            (!offlineOnly || isAvailable(r)))
          r,
    ];
  }

  /// Case- and diacritic-insensitive matching ("tho" finds "Thở").
  static String _fold(String s) {
    const from =
        'àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ';
    const to =
        'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd';
    final lower = s.toLowerCase();
    final buffer = StringBuffer();
    for (final ch in lower.split('')) {
      final i = from.indexOf(ch);
      buffer.write(i < 0 ? ch : to[i]);
    }
    return buffer.toString();
  }
}
