import 'package:flutter/material.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/component_tokens.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../domain/session_machine.dart';

class PlaybackControls extends StatelessWidget {
  const PlaybackControls({
    super.key,
    required this.status,
    required this.hasNext,
    required this.onPause,
    required this.onResume,
    required this.onPrevious,
    required this.onNext,
  });

  final SessionStatus status;
  final bool hasNext;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  /// One line that shrinks to fit: huge OS text size must not push the pinned
  /// controls off screen.
  Widget _label(String text) =>
      FittedBox(fit: BoxFit.scaleDown, child: Text(text, maxLines: 1));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final running =
        status == SessionStatus.playing ||
        status == SessionStatus.countdown ||
        status == SessionStatus.buffering;
    final canResume =
        status == SessionStatus.paused || status == SessionStatus.interrupted;
    final canSeek = running || canResume;
    // Large: the player is read from 1–2 m away.
    final bigStyle = FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(DistanceViewTokens.controlHeight),
      textStyle: DistanceTypography.body,
    );
    return Row(
      children: [
        IconButton(
          onPressed: canSeek ? onPrevious : null,
          tooltip: l10n.playerPrevious,
          icon: const Icon(Icons.skip_previous),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: running
              ? FilledButton.icon(
                  style: bigStyle,
                  onPressed: onPause,
                  icon: const Icon(Icons.pause),
                  label: _label(l10n.playerPause),
                )
              : FilledButton.icon(
                  style: bigStyle,
                  onPressed: canResume ? onResume : null,
                  icon: const Icon(Icons.play_arrow),
                  label: _label(l10n.playerResume),
                ),
        ),
        const SizedBox(width: AppSpacing.sm),
        IconButton(
          onPressed: canSeek && hasNext ? onNext : null,
          tooltip: l10n.playerNext,
          icon: const Icon(Icons.skip_next),
        ),
      ],
    );
  }
}

class ErrorControls extends StatelessWidget {
  const ErrorControls({
    super.key,
    required this.message,
    required this.canSkip,
    required this.onRetry,
    required this.onSkip,
    required this.onBack,
  });

  final String message;
  final bool canSkip;
  final VoidCallback onRetry;
  final VoidCallback onSkip;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(liveRegion: true, child: Text(message)),
        const SizedBox(height: AppSpacing.md),
        FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: Text(l10n.retry),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (canSkip)
          OutlinedButton(onPressed: onSkip, child: Text(l10n.playerSkip)),
        TextButton(onPressed: onBack, child: Text(l10n.playerBack)),
      ],
    );
  }
}
