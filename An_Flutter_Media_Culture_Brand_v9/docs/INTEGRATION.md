# Copy directly into an existing Flutter monorepo

1. Back up local modifications first (Git branch or commit).
2. Unzip `An_Nhien_Unified_Media_v0.7.zip` at the repository **root**.
3. Add to `apps/mobile/pubspec.yaml`:

```yaml
dependencies:
  an_nhien_eastern_content:
    path: ../../packages/an_nhien_eastern_content
flutter:
  assets:
    - assets/series/
    - assets/covers/
    - assets/listing/
    - assets/catalog/
    - assets/audio/cues/
```

4. Run `flutter pub get` and inspect assets. Dart usage:

```dart
final repository = EasternContentRepository();
final catalog = await repository.getDraftCatalog('baduanjin');
final exercise = (catalog['exercises'] as List)
    .firstWhere((e) => e['id'] == 'E101');
final media = (catalog['mediaAssets'] as List)
    .firstWhere((m) => m['id'] == exercise['posterMediaId']);
final posterKey = repository.imageKey(media['files'][0]['path']);
// Image.asset(posterKey) is for LISTING/DEVELOPER PREVIEW ONLY.
```

5. In production UI, use `visiblePublishedRoutines`, which continues to return no Eastern routines until expert review and publication. `posterMediaId` for all 60 now resolves to consistent teal/cream photo cards.
6. Do NOT show `03_poster_instruction.webp` or `04-07_step_*.webp` as approved practice instructions. They are draft references.
7. Do NOT use the old v0.6 preview-generated silhouettes at all.
8. Run: `python scripts/validate_content.py`, `python scripts/verify_unified_media.py`, `flutter analyze`, `flutter test`; then test on device.

Key issue: E04/E06 are copied byte-for-byte from v1.1 to preserve style, but they still have known technique errors. The release gate explicitly blocks them. Shoot/edit with an experienced instructor before publication.
