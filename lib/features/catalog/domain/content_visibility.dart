import 'catalog_models.dart';

/// Publication gate (P03): production shows only approved content; developer
/// preview may show draft/in-review content, always labelled as demo.
final class ContentVisibility {
  const ContentVisibility({required this.allowPreviewContent});

  final bool allowPreviewContent;

  bool _visible(ReviewStatus status, bool demoOnly) => switch (status) {
    ReviewStatus.retired => false,
    ReviewStatus.approved => allowPreviewContent || !demoOnly,
    ReviewStatus.draft || ReviewStatus.inReview => allowPreviewContent,
  };

  ContentCatalog apply(ContentCatalog catalog) {
    final media = catalog.mediaAssets
        .where((m) => _visible(m.reviewStatus, m.demoOnly))
        .toList();
    final mediaIds = {for (final m in media) m.id};
    final exercises = catalog.exercises
        .where(
          (e) =>
              _visible(e.reviewStatus, e.demoOnly) &&
              mediaIds.containsAll({e.posterMediaId, ...e.mediaAssetIds}),
        )
        .toList();
    final exerciseKeys = {for (final e in exercises) '${e.id}@${e.version}'};
    final routines = catalog.routines
        .where(
          (r) =>
              _visible(r.reviewStatus, r.demoOnly) &&
              r.steps.every(
                (s) => exerciseKeys.contains(
                  '${s.exerciseId}@${s.exerciseVersion}',
                ),
              ),
        )
        .toList();
    return ContentCatalog(
      catalogId: catalog.catalogId,
      catalogVersion: catalog.catalogVersion,
      locale: catalog.locale,
      demoOnly: catalog.demoOnly,
      exercises: exercises,
      routines: routines,
      mediaAssets: media,
    );
  }
}
