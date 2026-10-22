import 'package:an_nhien/features/catalog/data/catalog_manifest_parser.dart';
import 'package:an_nhien/features/catalog/domain/catalog_models.dart';
import 'package:an_nhien/features/library/domain/library_filter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../catalog/catalog_test_data.dart';

void main() {
  final catalog = const CatalogManifestParser().parse(readManifest());
  List<String> ids(LibraryFilter f, {bool Function(Routine)? available}) => f
      .apply(catalog, isAvailable: available ?? (_) => true)
      .map((r) => r.id)
      .toList();

  test('empty filter returns every routine', () {
    expect(const LibraryFilter().isEmpty, isTrue);
    expect(ids(const LibraryFilter()), [
      'R01',
      'R02',
      'R03',
      'R04',
      'R05',
      'R101',
    ]);
  });

  test(
    'search ignores case and Vietnamese diacritics, matches exercises too',
    () {
      expect(ids(const LibraryFilter(query: 'TOI')), ['R05']); // "tối"
      expect(ids(const LibraryFilter(query: 'di bo')), ['R02']); // E06 Đi bộ
    },
  );

  test('filters by tag, position and duration bucket', () {
    expect(ids(const LibraryFilter(tag: 'seated')), ['R03', 'R04', 'R05']);
    expect(ids(const LibraryFilter(position: BodyPosition.mixed)), [
      'R01',
      'R02',
      'R03',
      'R04',
    ]);
    expect(ids(const LibraryFilter(position: BodyPosition.seated)), ['R05']);
    expect(ids(const LibraryFilter(duration: DurationBucket.short)), [
      'R01',
      'R05',
    ]);
    expect(ids(const LibraryFilter(duration: DurationBucket.medium)), [
      'R03',
      'R04',
      'R101',
    ]);
    expect(ids(const LibraryFilter(duration: DurationBucket.long)), ['R02']);
  });

  test('offline-only keeps available routines', () {
    expect(
      ids(
        const LibraryFilter(offlineOnly: true),
        available: (r) => r.id == 'R01',
      ),
      ['R01'],
    );
  });

  test('copyWith can clear nullable fields', () {
    const f = LibraryFilter(tag: 'seated', position: BodyPosition.seated);
    final cleared = f.copyWith(tag: () => null);
    expect(cleared.tag, isNull);
    expect(cleared.position, BodyPosition.seated);
  });

  test('duration buckets are inclusive at the upper bound', () {
    expect(DurationBucket.of(const Duration(minutes: 6)), DurationBucket.short);
    expect(
      DurationBucket.of(const Duration(minutes: 7)),
      DurationBucket.medium,
    );
    expect(DurationBucket.of(const Duration(minutes: 11)), DurationBucket.long);
  });
}
