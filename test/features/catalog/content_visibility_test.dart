import 'dart:convert';

import 'package:an_nhien/features/catalog/data/catalog_manifest_parser.dart';
import 'package:an_nhien/features/catalog/domain/content_visibility.dart';
import 'package:flutter_test/flutter_test.dart';

import 'catalog_test_data.dart';

void main() {
  const parser = CatalogManifestParser();
  const production = ContentVisibility(allowPreviewContent: false);
  const preview = ContentVisibility(allowPreviewContent: true);

  test('production hides draft/demo content (P03)', () {
    final catalog = production.apply(parser.parse(draftManifest()));
    expect(catalog.routines, isEmpty);
    expect(catalog.exercises, isEmpty);
  });

  test('developer preview shows draft content', () {
    final catalog = preview.apply(parser.parse(draftManifest()));
    expect(catalog.routines, hasLength(6));
  });

  test('production shows approved non-demo content', () {
    final catalog = production.apply(parser.parse(readManifest()));
    expect(catalog.routines, hasLength(6));
    expect(catalog.routines.any(catalog.isPreviewOnly), isFalse);
  });

  test('routine is hidden when one of its exercises is not approved', () {
    final json = manifestJson();
    listOf(
      json,
      'exercises',
    ).firstWhere((e) => e['id'] == 'E07')['reviewStatus'] = 'in_review';
    final catalog = production.apply(parser.parse(jsonEncode(json)));
    // Every basic routine ends with E07; only Bát Đoạn Cẩm (R101) remains.
    expect(catalog.routines.map((r) => r.id), ['R101']);
  });

  test('retired content is hidden even in preview', () {
    final json = manifestJson();
    listOf(json, 'routines').first['reviewStatus'] = 'retired';
    final catalog = preview.apply(parser.parse(jsonEncode(json)));
    expect(catalog.routine('R01'), isNull);
    expect(catalog.routines, hasLength(5));
  });
}
