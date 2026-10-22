import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/catalog_providers.dart';
import '../domain/catalog_models.dart';
import 'exercise_image.dart';

/// Routine cover when bundled, else the first exercise thumbnail.
class RoutineImage extends ConsumerWidget {
  const RoutineImage({super.key, required this.catalog, required this.routine});

  final ContentCatalog catalog;
  final Routine routine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final available = ref.watch(availableMediaProvider).value ?? const {};
    final first = catalog.exerciseFor(routine.steps.first);
    final cover = available.contains(routine.coverPath)
        ? routine.coverPath
        : null;
    return ExerciseImage(
      path: cover ?? catalog.thumbnailOf(first),
      semanticLabel: routine.title,
    );
  }
}
