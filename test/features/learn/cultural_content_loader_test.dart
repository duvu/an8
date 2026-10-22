import 'dart:convert';

import 'package:an_nhien/features/learn/data/cultural_content_loader.dart';
import 'package:an_nhien_cultural_content/an_nhien_cultural_content.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Serves the given JSON documents by asset key.
final class _MapBundle extends CachingAssetBundle {
  _MapBundle(this.files);

  final Map<String, Object> files;

  @override
  Future<ByteData> load(String key) async {
    final file = files[key];
    if (file == null) throw StateError('missing $key');
    return ByteData.sublistView(utf8.encode(jsonEncode(file)));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads the bundled pack: 67 stories, 7 profiles, 6 stories', () async {
    rootBundle.clear();
    final loader = CulturalContentLoader(CulturalContentRepository());
    final content = await loader.load();

    for (final id in ['E01', 'E07', 'E101', 'E108', 'E524']) {
      expect(content.storyFor(id), isNotNull, reason: id);
    }
    for (final id in ['basics', 'baduanjin', 'xisuijing']) {
      expect(content.profileFor(id), isNotNull, reason: id);
    }
    expect(content.episodes, hasLength(6));

    // A pointer to the system profile is not shown as a note …
    expect(content.storyFor('E101')!.historicalNote, isNull);
    // … a real note is.
    expect(
      content.storyFor('E01')!.historicalNote,
      contains('chương trình An'),
    );

    final refs = content.referencesFor(content.storyFor('E101')!.sourceIds);
    expect(refs.map((r) => r.id), [
      'BADUANJIN_HISTORY',
      'CHQA_FOUR',
      'DAOYIN_REVIEW',
    ]);
    expect(refs.every((r) => r.url.startsWith('https://')), isTrue);

    final text = await loader.script(content.episodes.first);
    expect(text.trim(), isNotEmpty);
  });

  test('a story without its meaning is rejected, not half-rendered', () async {
    const prefix = 'packages/an_nhien_cultural_content/assets';
    final bundle = _MapBundle({
      '$prefix/sources/references.vi.v1.json': {'items': <Object>[]},
      '$prefix/catalog/systems.vi.v1.json': {'systems': <Object>[]},
      '$prefix/catalog/speaker_episodes.vi.v1.json': {'episodes': <Object>[]},
      '$prefix/catalog/exercise_stories.vi.v1.json': {
        'exercises': [
          {
            'exerciseId': 'E01',
            'title': 'Thở tự nhiên',
            'culturalAngle': 'x',
            'meaning': '  ',
            'movementAwareness': 'x',
            'historicalNote': 'x',
            'sourceIds': <String>[],
          },
        ],
      },
    });
    final loader = CulturalContentLoader(
      CulturalContentRepository(bundle: bundle),
    );
    await expectLater(loader.load(), throwsFormatException);
  });
}
