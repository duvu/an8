import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../application/preferences_controller.dart';
import '../application/reminder_actions.dart';
import 'settings_widgets.dart';

/// Daily "time to practise" reminder: switch and time.
class DailyReminderSection extends ConsumerWidget {
  const DailyReminderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final prefs = ref.watch(preferencesProvider);

    Future<void> setReminder(bool enabled, int minutes) async {
      final messenger = ScaffoldMessenger.of(context);
      try {
        final result = await ref
            .read(reminderActionsProvider)
            .setDaily(
              enabled: enabled,
              minutesOfDay: minutes,
              title: l10n.reminderTitle,
              body: l10n.reminderBody,
            );
        if (result == ReminderResult.permissionDenied) {
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.settingsReminderDenied)),
          );
        }
      } on Exception {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.settingsReminderError)),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(l10n.settingsReminderSection),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.settingsReminder),
          subtitle: Text(
            l10n.settingsReminderTime(
              formatMinutesOfDay(context, prefs.reminderMinutes),
            ),
          ),
          value: prefs.reminderEnabled,
          onChanged: (v) => setReminder(v, prefs.reminderMinutes),
        ),
        OutlinedButton.icon(
          onPressed: () async {
            final minutes = await pickMinutesOfDay(
              context,
              prefs.reminderMinutes,
            );
            if (minutes == null) return;
            if (prefs.reminderEnabled) {
              await setReminder(true, minutes);
            } else {
              await ref
                  .read(preferencesProvider.notifier)
                  .update((p) => p.copyWith(reminderMinutes: minutes));
            }
          },
          icon: const Icon(Icons.schedule),
          label: Text(l10n.settingsReminderChangeTime),
        ),
      ],
    );
  }
}
