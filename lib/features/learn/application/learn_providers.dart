import 'package:an_nhien_cultural_content/an_nhien_cultural_content.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../catalog/application/catalog_providers.dart';
import '../data/cultural_content_loader.dart';
import '../domain/cultural_content.dart';

final culturalContentLoaderProvider = Provider<CulturalContentLoader>(
  (ref) => CulturalContentLoader(
    CulturalContentRepository(bundle: ref.watch(assetBundleProvider)),
  ),
);

/// Shown in every build as reading material (D17).
final culturalContentProvider = FutureProvider<CulturalContent>(
  (ref) => ref.watch(culturalContentLoaderProvider).load(),
);

/// Episode title + text by id; null when the id is unknown.
final episodeProvider =
    FutureProvider.family<({StoryEpisode episode, String text})?, String>((
      ref,
      id,
    ) async {
      final content = await ref.watch(culturalContentProvider.future);
      final episode = content.episodes.where((e) => e.id == id).firstOrNull;
      if (episode == null) return null;
      final text = await ref
          .watch(culturalContentLoaderProvider)
          .script(episode);
      return (episode: episode, text: text.trim());
    });
