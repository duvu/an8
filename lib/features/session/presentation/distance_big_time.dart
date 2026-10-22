import 'package:flutter/material.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../../../core/ui/formatters.dart';
import '../application/session_controller.dart';
import '../domain/session_machine.dart';

/// The step countdown in very large digits (3-2-1 during the countdown).
class DistanceBigTime extends StatelessWidget {
  const DistanceBigTime({super.key, required this.view, required this.ending});

  final SessionViewState view;
  final bool ending;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final snapshot = view.snapshot;
    final counting = snapshot.status == SessionStatus.countdown;
    final time = formatClock(view.stepRemaining);
    final digits = counting
        ? '${(snapshot.countdownRemaining.inMilliseconds / 1000).ceil()}'
        : time;
    // Right under the digits so it is never scrolled out of view (P14):
    // the step-ending warning, else why the clock is stopped, else "còn lại".
    final (String? line, Color? lineColor) = switch (snapshot.status) {
      _ when ending => (
        view.hasNext
            ? l10n.distanceEndingNext(
                view.plan.steps[snapshot.stepIndex + 1].exercise.title,
              )
            : l10n.distanceEndingLast,
        colors.warning,
      ),
      SessionStatus.idle ||
      SessionStatus.preparing => (l10n.playerPreparing, null),
      SessionStatus.paused => (l10n.playerPaused, colors.warning),
      SessionStatus.interrupted => (l10n.playerInterrupted, colors.warning),
      SessionStatus.buffering => (l10n.playerBuffering, null),
      SessionStatus.countdown => (null, null),
      _ => (l10n.distanceRemaining, null),
    };
    return Column(
      children: [
        Semantics(
          container: true,
          label: l10n.distanceTimerLabel(view.currentStep.exercise.title, time),
          child: ExcludeSemantics(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                digits,
                style: DistanceTypography.time.copyWith(
                  color: ending ? colors.warning : colors.textPrimary,
                ),
              ),
            ),
          ),
        ),
        if (line != null)
          Semantics(
            container: true,
            liveRegion: lineColor != null,
            // Plain "còn lại" is already part of the timer label above.
            excludeSemantics: line == l10n.distanceRemaining,
            child: Text(
              line,
              textAlign: TextAlign.center,
              style:
                  (lineColor != null
                          ? theme.textTheme.titleLarge
                          : theme.textTheme.titleMedium)
                      ?.copyWith(color: lineColor ?? colors.textSecondary),
            ),
          ),
      ],
    );
  }
}
