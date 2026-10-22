import '../../catalog/domain/catalog_models.dart';

/// A traditional Eastern practice system (Bát Đoạn Cẩm, Thái Cực…), shown as an
/// introduction only: there is no playable, reviewed technique yet (D09).
final class PracticeForm {
  const PracticeForm({
    required this.exerciseId,
    required this.number,
    required this.titleVi,
    required this.originalName,
    this.illustrationKey,
  });

  final String exerciseId;
  final int number;
  final String titleVi;
  final String originalName;

  /// Draft listing card that really depicts this form (asset key), or null when
  /// only a same-system card exists. Never an approved instruction (D11).
  final String? illustrationKey;
}

/// A reference picture of several forms at once (e.g. Tai Chi 24, forms
/// 1–8), for getting to know names and shapes. Not technique instruction
/// (D21).
final class OverviewBoard {
  const OverviewBoard({
    required this.id,
    required this.title,
    required this.assetKey,
  });

  final String id;
  final String title;

  /// Full asset key (package prefix included), ready for `Image.asset`.
  final String assetKey;
}

final class PracticeSystem {
  PracticeSystem({
    required this.slug,
    required this.titleVi,
    required this.titleOriginal,
    required this.formCount,
    required this.coverAssetKey,
    required this.researchOnly,
    required List<PracticeForm> forms,
    required List<String> safetyNotes,
    required List<String> sources,
    required List<String> requiredBeforeAuthoring,
    this.routineIds = const [],
    List<OverviewBoard> overviewBoards = const [],
    this.summary,
    this.level,
    this.notes,
  }) : forms = List.unmodifiable(forms),
       safetyNotes = List.unmodifiable(safetyNotes),
       sources = List.unmodifiable(sources),
       requiredBeforeAuthoring = List.unmodifiable(requiredBeforeAuthoring),
       overviewBoards = List.unmodifiable(overviewBoards);

  final String slug;
  final String titleVi;
  final String titleOriginal;
  final int formCount;

  /// Full asset key (package prefix included), ready for `Image.asset`.
  final String coverAssetKey;

  /// No sequence defined yet (e.g. Tẩy Tủy Kinh): nothing to list but the reason.
  final bool researchOnly;
  final String? summary;

  /// Raw level from the content pack (e.g. `gentle-to-moderate`).
  final String? level;

  /// Lineage notes, or the reason a research-only system has no forms.
  final String? notes;
  final List<PracticeForm> forms;
  final List<String> safetyNotes;
  final List<String> sources;
  final List<String> requiredBeforeAuthoring;

  /// Routines of this system; playable only once published in the app catalog.
  final List<String> routineIds;

  /// Overview boards of this system's routines, in reading order.
  final List<OverviewBoard> overviewBoards;

  /// First routine of this system that is published in [catalog], if any.
  Routine? playableRoutine(ContentCatalog? catalog) {
    if (catalog == null) return null;
    for (final id in routineIds) {
      if (catalog.routine(id) case final routine?) return routine;
    }
    return null;
  }
}
