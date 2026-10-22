import 'dart:convert';

import 'package:an_nhien/features/eastern/data/eastern_systems_repository.dart';
import 'package:an_nhien_eastern_content/an_nhien_eastern_content.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory bundle for malformed-content cases.
final class _MapBundle extends CachingAssetBundle {
  _MapBundle(this.files);

  final Map<String, String> files;

  @override
  Future<ByteData> load(String key) async {
    final text = files[key];
    if (text == null) throw StateError('missing $key');
    return ByteData.sublistView(utf8.encode(text));
  }
}

const _prefix = 'packages/an_nhien_eastern_content/assets/catalog/';

Map<String, String> _pack({
  required Map<String, Object?> sidecar,
  Map<String, Object?>? overview,
}) => {
  '${_prefix}taichi24_overview.v9.json': jsonEncode(
    overview ??
        {
          'routineId': 'R101',
          'pages': [
            {
              'id': 'p1',
              'title': 'Thức 1–8',
              'asset': 'assets/education/b1.webp',
            },
          ],
        },
  ),
  '${_prefix}index.v1.json': jsonEncode({
    'practiceSystems': [
      {'slug': 'baduanjin'},
    ],
  }),
  '${_prefix}baduanjin.system.v1.json': jsonEncode(sidecar),
  '${_prefix}listing_media.v1.json': jsonEncode({
    'exercises': [
      {
        'id': 'E101',
        'coverPath': 'assets/listing/E101_cover.webp',
        'coverIsExerciseSpecific': true,
      },
    ],
  }),
};

Map<String, Object?> _validSidecar() => {
  'titleVi': 'Bát Đoạn Cẩm',
  'titleEn': 'Ba Duan Jin',
  'numberOfForms': 1,
  'coverPath': 'assets/covers/baduanjin.webp',
  'exerciseTitles': [
    {
      'exerciseId': 'E101',
      'number': 1,
      'titleVi': 'Song thủ thác thiên',
      'sourceNameEn': 'Two Hands',
    },
  ],
  'safetyPolicy': ['Không nín thở.'],
  'sourceReferences': <String>[],
  'routineIds': ['R101'],
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('bundled eastern content pack', () {
    final repository = EasternSystemsRepository(EasternContentRepository());

    test('reads 6 systems with their forms, in pack order', () async {
      final systems = await repository.getSystems();
      expect(systems.map((s) => s.titleVi), [
        'Bát Đoạn Cẩm',
        'Dịch Cân Kinh',
        'Ngũ Cầm Hí',
        'Lục Tự Quyết',
        'Thái Cực Quyền 24 thức',
        'Tẩy Tủy Kinh / Tẩy Tủy Công',
      ]);
      expect(systems.map((s) => s.formCount), [8, 12, 10, 6, 24, 0]);
      final first = systems.first.forms.first;
      expect(first.number, 1);
      expect(first.titleVi, 'Song thủ thác thiên');
      expect(first.originalName, 'Two Hands Hold up the Heavens');
      expect(systems.first.sources, isNotEmpty);
      expect(systems.first.safetyNotes, isNotEmpty);
    });

    test('Tẩy Tủy Kinh is research-only with no invented forms', () async {
      final xi = (await repository.getSystems()).last;
      expect(xi.researchOnly, isTrue);
      expect(xi.forms, isEmpty);
      expect(xi.notes, contains('Chưa xác định'));
      expect(xi.requiredBeforeAuthoring, hasLength(4));
    });

    test('only form-specific illustration cards are attached (D11)', () async {
      final forms = [for (final s in await repository.getSystems()) ...s.forms];
      final illustrated = forms.where((f) => f.illustrationKey != null);
      expect(illustrated.map((f) => f.exerciseId), [
        'E101',
        'E102',
        'E103',
        'E104',
        'E105',
        'E106',
        'E107',
        'E108',
        'E201',
        'E301',
        'E309',
        'E401',
        'E501',
        'E503',
      ]);
      expect(
        forms.firstWhere((f) => f.exerciseId == 'E210').illustrationKey,
        isNull,
      );
      final assets = (await AssetManifest.loadFromAssetBundle(rootBundle))
          .listAssets();
      for (final f in illustrated) {
        expect(assets, contains(f.illustrationKey), reason: f.exerciseId);
      }
    });

    test('Thái Cực 24 gets its 3 bundled overview boards (v9)', () async {
      final systems = await repository.getSystems();
      final taichi = systems.firstWhere((s) => s.slug == 'taichi24');
      expect(taichi.overviewBoards.map((b) => b.title), [
        'Thức 1–8',
        'Thức 9–16',
        'Thức 17–24',
      ]);
      expect(
        systems.where((s) => s.overviewBoards.isNotEmpty).map((s) => s.slug),
        ['taichi24'],
      );
      final assets = (await AssetManifest.loadFromAssetBundle(rootBundle))
          .listAssets();
      for (final b in taichi.overviewBoards) {
        expect(assets, contains(b.assetKey), reason: b.id);
      }
      // Only the compressed boards; the 1.8 MB PNG masters stay out.
      expect(
        assets.where((a) => a.contains('assets/education/')),
        hasLength(3),
      );
    });

    test(
      'covers are bundled; only published step photos from series',
      () async {
        final systems = await repository.getSystems();
        final assets = (await AssetManifest.loadFromAssetBundle(rootBundle))
            .listAssets();
        for (final s in systems) {
          expect(assets, contains(s.coverAssetKey));
        }
        // Only step photos of published forms (D13); never title/review/poster.
        final series = assets.where(
          (a) => a.contains('an_nhien_eastern_content/assets/series'),
        );
        expect(series, hasLength(32));
        expect(series.every((a) => a.contains('_step_')), isTrue);
      },
    );
  });

  group('rejects malformed sidecars', () {
    EasternSystemsRepository repo(Map<String, Object?> sidecar) =>
        EasternSystemsRepository(
          EasternContentRepository(bundle: _MapBundle(_pack(sidecar: sidecar))),
        );

    test('valid minimal sidecar parses', () async {
      final systems = await repo(_validSidecar()).getSystems();
      expect(
        systems.single.forms.single.illustrationKey,
        'packages/an_nhien_eastern_content/assets/listing/E101_cover.webp',
      );
      expect(
        systems.single.coverAssetKey,
        'packages/an_nhien_eastern_content/assets/covers/baduanjin.webp',
      );
    });

    test('board paths may be relative or full keys', () async {
      final systems = await repo(_validSidecar()).getSystems();
      expect(
        systems.single.overviewBoards.single.assetKey,
        'packages/an_nhien_eastern_content/assets/education/b1.webp',
      );
    });

    test('a board without an image is rejected', () async {
      final repository = EasternSystemsRepository(
        EasternContentRepository(
          bundle: _MapBundle(
            _pack(
              sidecar: _validSidecar(),
              overview: {
                'routineId': 'R101',
                'pages': [
                  {'id': 'p1', 'title': 'Thức 1–8'},
                ],
              },
            ),
          ),
        ),
      );
      expect(repository.getSystems(), throwsFormatException);
    });

    test('form count must match the listed forms', () async {
      final sidecar = _validSidecar()..['numberOfForms'] = 8;
      expect(repo(sidecar).getSystems(), throwsFormatException);
    });

    test('missing title', () async {
      final sidecar = _validSidecar()..remove('titleVi');
      expect(repo(sidecar).getSystems(), throwsFormatException);
    });
  });
}
