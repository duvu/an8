import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../application/preferences_controller.dart';
import '../domain/preferences.dart';
import 'settings_widgets.dart';

/// Switches that apply while practising; each change persists immediately.
class PracticeSettingsSection extends ConsumerWidget {
  const PracticeSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final prefs = ref.watch(preferencesProvider);
    final controller = ref.read(preferencesProvider.notifier);

    Widget toggle(
      String title,
      String hint,
      bool value,
      Preferences Function(Preferences, bool) apply,
    ) => SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(hint),
      value: value,
      onChanged: (v) => controller.update((p) => apply(p, v)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(l10n.settingsPracticeSection),
        toggle(
          l10n.settingsCaptions,
          l10n.settingsCaptionsHint,
          prefs.captionsEnabled,
          (p, v) => p.copyWith(captionsEnabled: v),
        ),
        toggle(
          l10n.settingsReducedMotion,
          l10n.settingsReducedMotionHint,
          prefs.reducedMotion,
          (p, v) => p.copyWith(reducedMotion: v),
        ),
        toggle(
          l10n.settingsSoundCues,
          l10n.settingsSoundCuesHint,
          prefs.soundCues,
          (p, v) => p.copyWith(soundCues: v),
        ),
        toggle(
          l10n.settingsBackgroundMusic,
          l10n.settingsBackgroundMusicHint,
          prefs.backgroundMusic,
          (p, v) => p.copyWith(backgroundMusic: v),
        ),
        Text(
          l10n.settingsTextSizeHint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.appColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
