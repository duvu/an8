import 'dart:convert';

import 'package:an_nhien/features/catalog/data/catalog_manifest_parser.dart';
import 'package:an_nhien/features/catalog/domain/catalog_models.dart';
import 'package:flutter_test/flutter_test.dart';

import 'catalog_test_data.dart';

void main() {
  const parser = CatalogManifestParser();

  group('bundled published manifest', () {
    final catalog = parser.parse(readManifest());

    test('has 15 exercises, 6 routines and 15 media collections', () {
      expect(catalog.exercises, hasLength(15));
      expect(catalog.routines, hasLength(6));
      expect(catalog.mediaAssets, hasLength(15));
      expect(catalog.demoOnly, isFalse);
    });

    test('aggregates routine durations from steps', () {
      expect(catalog.routine('R01')!.totalDuration, const Duration(minutes: 6));
      expect(
        catalog.routine('R02')!.totalDuration,
        const Duration(minutes: 14),
      );
    });

    test('maps snake_case enums and derives routine position', () {
      final e01 = catalog.exercise('E01', 1)!;
      expect(e01.position, BodyPosition.seated);
      expect(e01.reviewStatus, ReviewStatus.approved);
      expect(catalog.positionOf(catalog.routine('R05')!), BodyPosition.seated);
      expect(catalog.positionOf(catalog.routine('R02')!), BodyPosition.mixed);
    });

    test('resolves thumbnails and required files', () {
      final e01 = catalog.exercise('E01', 1)!;
      expect(catalog.thumbnailOf(e01), 'assets/series/E01/thumbnail.png');
      final r01 = catalog.routine('R01')!;
      // E01(4) + E02(4) + E07(4) frames + 3 thumbnails.
      expect(catalog.requiredFilesOf(r01), hasLength(15));
    });

    test('published content is not preview-only', () {
      expect(catalog.routines.any(catalog.isPreviewOnly), isFalse);
    });

    test('draft variant is preview-only', () {
      final draft = parser.parse(draftManifest());
      expect(draft.routines.every(draft.isPreviewOnly), isTrue);
    });
  });

  group('rejects invalid manifests', () {
    void expectIssue(Map<String, Object?> json, Matcher issue) {
      expect(
        () => parser.parse(jsonEncode(json)),
        throwsA(
          isA<CatalogFormatException>().having(
            (e) => e.issues,
            'issues',
            contains(issue),
          ),
        ),
      );
    }

    test('malformed JSON', () {
      expect(() => parser.parse('{'), throwsA(isA<CatalogFormatException>()));
    });

    test('unsupported schema version', () {
      expectIssue(
        manifestJson()..['schemaVersion'] = 2,
        contains('unsupported 2'),
      );
    });

    test('missing required field', () {
      final json = manifestJson();
      listOf(json, 'exercises').first.remove('title');
      expectIssue(json, contains(r'$.exercises[0].title'));
    });

    test('unknown enum value', () {
      final json = manifestJson();
      listOf(json, 'exercises').first['position'] = 'lying';
      expectIssue(json, contains('unknown value "lying"'));
    });

    test('declared total differs from step sum', () {
      final json = manifestJson();
      listOf(json, 'routines').first['totalDurationSeconds'] = 1;
      expectIssue(json, contains('totalDurationSeconds'));
    });

    test('routine step references unknown exercise version', () {
      final json = manifestJson();
      listOf(listOf(json, 'routines').first, 'steps').first['exerciseVersion'] =
          9;
      expectIssue(json, contains('unknown exercise E01@9'));
    });

    test('exercise references unknown media', () {
      final json = manifestJson();
      listOf(json, 'exercises').first['posterMediaId'] = 'MISSING';
      expectIssue(json, contains('unknown media MISSING'));
    });

    test('duplicate ids', () {
      final json = manifestJson();
      final exercises = listOf(json, 'exercises');
      json['exercises'] = [...exercises, exercises.first];
      expectIssue(json, contains('duplicate exercise E01@1'));
    });

    test('step order gap', () {
      final json = manifestJson();
      listOf(listOf(json, 'routines').first, 'steps').last['order'] = 9;
      expectIssue(json, contains('R01.steps: order'));
    });
  });
}
