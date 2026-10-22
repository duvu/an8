import 'package:an_brand/an_brand.dart';
import 'package:flutter/material.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/theme/component_tokens.dart';
import '../../../app/theme/semantic_tokens.dart';

enum PauseChoice { resume, stop }

/// Small panel over the paused player: continue, or stop for good (saved as
/// not completed). Dismissing it keeps the session paused.
Future<PauseChoice?> showPauseDialog(BuildContext context) {
  // The caller's context sits above the player's own night Theme, so both the
  // scrim and the panel take the night theme explicitly; otherwise they turn
  // bright (light theme) over the dark player.
  final night = AppTheme.night;
  return showDialog<PauseChoice>(
    context: context,
    barrierColor: night.dialogTheme.barrierColor,
    builder: (_) => Theme(
      data: night,
      child: const Builder(builder: _panel),
    ),
  );
}

Widget _panel(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  final theme = Theme.of(context);
  // Same big controls as the player; colours, shape and scrim come from the
  // theme's dialog/button tokens, so the panel matches the rest of the app.
  const big = Size.fromHeight(DistanceViewTokens.controlHeight);
  Widget label(String text) =>
      FittedBox(fit: BoxFit.scaleDown, child: Text(text, maxLines: 1));
  return Dialog(
    insetPadding: const EdgeInsets.all(AppSpacing.xl),
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mark beside the title: short landscape screens still fit both
            // buttons.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AnLotus(
                  size: DialogTokens.brandMarkSize,
                  semanticLabel: '',
                ),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    l10n.pauseTitle,
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.pauseMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.appColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                minimumSize: big,
                textStyle: DistanceTypography.body,
              ),
              onPressed: () => Navigator.of(context).pop(PauseChoice.resume),
              icon: const Icon(Icons.play_arrow),
              label: label(l10n.pauseResume),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: big,
                textStyle: DistanceTypography.body,
              ),
              onPressed: () => Navigator.of(context).pop(PauseChoice.stop),
              icon: const Icon(Icons.stop),
              label: label(l10n.pauseStop),
            ),
          ],
        ),
      ),
    ),
  );
}
