import 'package:flutter/material.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/component_tokens.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../../../core/ui/formatters.dart';
import '../application/session_controller.dart';

class DistanceInfo extends StatelessWidget {
  const DistanceInfo({
    super.key,
    required this.view,
    required this.ending,
    required this.showCaptions,
    required this.reduceMotion,
  });

  final SessionViewState view;
  final bool ending;
  final bool showCaptions;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final snapshot = view.snapshot;
    final step = view.currentStep;
    final frame = step.frameAt(view.stepOffset);
    final nextTitle = view.hasNext
        ? view.plan.steps[snapshot.stepIndex + 1].exercise.title
        : null;
    final total = view.plan.timeline.total;
    final progress = (snapshot.position.inMilliseconds / total.inMilliseconds)
        .clamp(0.0, 1.0);
    final announce = reduceMotion ? Duration.zero : DistanceViewTokens.announce;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // The step name is what changes every few minutes: cross-fade it.
        AnimatedSwitcher(
          duration: announce,
          child: Text(
            step.exercise.title,
            key: ValueKey(snapshot.stepIndex),
            textAlign: TextAlign.center,
            style: DistanceTypography.title,
          ),
        ),
        if (showCaptions) ...[
          const SizedBox(height: AppSpacing.sm),
          Semantics(
            liveRegion: true,
            child: Text(
              frame.instruction,
              textAlign: TextAlign.center,
              style: DistanceTypography.body,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        if (nextTitle != null && !ending) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.distanceNextUp(nextTitle),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        Semantics(
          label: l10n.playerProgressLabel((progress * 100).round()),
          child: ExcludeSemantics(
            child: LinearProgressIndicator(
              value: progress,
              minHeight: AppSpacing.sm,
              borderRadius: const BorderRadius.all(
                Radius.circular(AppRadius.sm),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.playerTotalRemaining(formatClock(view.totalRemaining)),
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
        ),
      ],
    );
  }
}
