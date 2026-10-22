import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/component_tokens.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../application/session_controller.dart';
import '../application/session_cues.dart';
import '../domain/session_machine.dart';
import 'distance_big_time.dart';
import 'distance_framed_media.dart';
import 'distance_info.dart';
import 'player_controls.dart';

/// Distance view: a phone placed 1–2 m away. The exercise image, time, step
/// name and an advance warning are readable at a glance; controls are large. Expects to be built
/// under the night theme.
class DistanceTimerView extends StatelessWidget {
  const DistanceTimerView({
    super.key,
    required this.view,
    required this.showCaptions,
    required this.reduceMotion,
    required this.header,
    required this.onPause,
    required this.onResume,
    required this.onPrevious,
    required this.onNext,
    required this.onRetry,
    required this.onSkip,
    required this.onBack,
  });

  final SessionViewState view;
  final bool showCaptions;
  final bool reduceMotion;
  final Widget header;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onRetry;
  final VoidCallback onSkip;
  final VoidCallback onBack;

  bool get _isEnding {
    final status = view.snapshot.status;
    return status == SessionStatus.playing &&
        view.stepRemaining <= stepEndingWarning;
  }

  @override
  Widget build(BuildContext context) {
    final controls = view.snapshot.status == SessionStatus.error
        ? ErrorControls(
            message:
                view.snapshot.errorMessage ??
                AppLocalizations.of(context).playerError,
            canSkip: view.hasNext,
            onRetry: onRetry,
            onSkip: onSkip,
            onBack: onBack,
          )
        : PlaybackControls(
            status: view.snapshot.status,
            hasNext: view.hasNext,
            onPause: onPause,
            onResume: onResume,
            onPrevious: onPrevious,
            onNext: onNext,
          );
    // Controls are pinned: nobody 2 m away can scroll to find Pause.
    final pinnedControls = Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.sm,
        AppSpacing.pageHorizontal,
        AppSpacing.lg,
      ),
      child: controls,
    );
    final info = DistanceInfo(
      view: view,
      ending: _isEnding,
      showCaptions: showCaptions,
      reduceMotion: reduceMotion,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final landscape = constraints.maxWidth > constraints.maxHeight * 1.1;
        // Portrait: the image gets what is left after header, digits, status
        // line and pinned controls, so those always fit on screen (P14).
        double mediaSide(double width) => landscape
            ? math.min(
                width,
                constraints.maxHeight *
                    DistanceViewTokens.mediaLandscapeHeightFraction,
              )
            : [
                width,
                constraints.maxHeight * DistanceViewTokens.mediaHeightFraction,
                constraints.maxHeight -
                    DistanceViewTokens.portraitReservedHeight,
              ].reduce(math.min).clamp(DistanceViewTokens.mediaMinSide, width);
        Widget media(double width) => DistanceFramedMedia(
          view: view,
          ending: _isEnding,
          reduceMotion: reduceMotion,
          side: mediaSide(width),
        );
        final time = DistanceBigTime(view: view, ending: _isEnding);
        const pageInsets = EdgeInsets.symmetric(
          horizontal: AppSpacing.pageHorizontal,
        );

        if (landscape) {
          final half = constraints.maxWidth / 2 - AppSpacing.pageHorizontal;
          return Column(
            children: [
              Padding(
                padding: pageInsets.copyWith(top: AppSpacing.sm),
                child: header,
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: Center(child: media(half))),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              padding: pageInsets,
                              children: [time, info],
                            ),
                          ),
                          pinnedControls,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: pageInsets.copyWith(top: AppSpacing.sm),
                children: [
                  header,
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: media(
                      constraints.maxWidth - 2 * AppSpacing.pageHorizontal,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  time,
                  info,
                ],
              ),
            ),
            pinnedControls,
          ],
        );
      },
    );
  }
}
