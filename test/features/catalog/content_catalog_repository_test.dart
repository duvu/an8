import 'package:an_nhien/features/catalog/application/catalog_providers.dart';
import 'package:an_nhien/features/catalog/data/catalog_data_source.dart';
import 'package:an_nhien/features/catalog/data/catalog_manifest_parser.dart';
import 'package:an_nhien/features/catalog/data/content_catalog_repository.dart';
import 'package:an_nhien/features/catalog/data/media_availability.dart';
import 'package:an_nhien/features/catalog/domain/content_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'catalog_test_data.dart';

final class _FakeSource implements CatalogDataSource {
  _FakeSource(this.responses);

  final List<String> responses;
  int reads = 0;

  @override
  Future<String> readManifest() async => responses[reads++];
}

final class _FakeMedia implements MediaAvailability {
  const _FakeMedia(this.paths);

  final Set<String> paths;

  @override
  Future<Set<String>> availablePaths() async => paths;
}

void main() {
  const preview = ContentVisibility(allowPreviewContent: true);

  test('caches the catalog and reloads on forceRefresh', () async {
    final source = _FakeSource([readManifest(), readManifest()]);
    final repo = DefaultContentCatalogRepository(
      dataSource: source,
      visibility: preview,
    );

    await repo.getCatalog();
    await repo.getCatalog();
    expect(source.reads, 1);
    await repo.getCatalog(forceRefresh: true);
    expect(source.reads, 2);
    expect((await repo.getRoutine('R02'))!.steps, hasLength(7));
    expect(await repo.getExercise('E99', 1), isNull);
  });

  test('a failed load is not cached; next call retries', () async {
    final source = _FakeSource(['{', readManifest()]);
    final repo = DefaultContentCatalogRepository(
      dataSource: source,
      visibility: preview,
    );

    await expectLater(
      repo.getCatalog(),
      throwsA(isA<CatalogFormatException>()),
    );
    expect((await repo.getCatalog()).routines, hasLength(6));
  });

  group('routine availability', () {
    ProviderContainer container(MediaAvailability media) {
      final c = ProviderContainer(
        overrides: [
          contentVisibilityProvider.overrideWithValue(preview),
          catalogRepositoryProvider.overrideWithValue(
            DefaultContentCatalogRepository(
              dataSource: _FakeSource([readManifest()]),
              visibility: preview,
            ),
          ),
          mediaAvailabilityProvider.overrideWithValue(media),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    test('is false when a required frame is missing', () async {
      final c = container(const _FakeMedia({}));
      expect(await c.read(routineAvailableProvider('R01').future), isFalse);
    });

    test('is false for an unknown routine', () async {
      final c = container(const _FakeMedia({}));
      expect(await c.read(routineAvailableProvider('R99').future), isFalse);
    });
  });

  testWidgets('every routine is fully bundled with the app', (tester) async {
    final c = ProviderContainer(
      overrides: [contentVisibilityProvider.overrideWithValue(preview)],
    );
    addTearDown(c.dispose);

    await tester.runAsync(() async {
      final catalog = await c.read(catalogProvider.future);
      for (final routine in catalog.routines) {
        expect(
          await c.read(routineAvailableProvider(routine.id).future),
          isTrue,
          reason: routine.id,
        );
      }
    });
  });
}
