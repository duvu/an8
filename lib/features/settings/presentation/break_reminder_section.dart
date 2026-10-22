import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../application/preferences_controller.dart';
import '../application/reminder_actions.dart';
import '../domain/break_reminder.dart';
import '../domain/preferences.dart';
import 'settings_widgets.dart';

/// "Stand up and move" reminders (D24): switch, interval, window and alert
/// type. While on, every change is rescheduled at once.
class BreakReminderSection extends ConsumerWidget {
  const BreakReminderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final prefs = ref.watch(preferencesProvider);

    Future<void> apply(Preferences next) async {
      final messenger = ScaffoldMessenger.of(context);
      try {
        final result = await ref
            .read(reminderActionsProvider)
            .setBreaks(
              enabled: next.breakReminderEnabled,
              intervalMinutes: next.breakIntervalMinutes,
              startMinutes: next.breakStartMinutes,
              endMinutes: next.breakEndMinutes,
              alert: next.breakAlert,
              title: l10n.reminderTitle,
              bodies: [
                l10n.breakReminderBody1,
                l10n.breakReminderBody2,
                l10n.breakReminderBody3,
              ],
            );
        final message = switch (result) {
          ReminderResult.permissionDenied => l10n.settingsReminderDenied,
          ReminderResult.invalidWindow => l10n.settingsBreakInvalidWindow,
          _ => null,
        };
        if (message != null) {
          messenger.showSnackBar(SnackBar(content: Text(message)));
        }
      } on Exception {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.settingsReminderError)),
        );
      }
    }

    // Reschedules only while the reminder is on; otherwise just saves.
    Future<void> change(Preferences Function(Preferences) edit) async {
      if (prefs.breakReminderEnabled) {
        await apply(edit(prefs));
      } else {
        await ref.read(preferencesProvider.notifier).update(edit);
      }
    }

    Future<void> pickTime(
      int current,
      Preferences Function(Preferences, int) set,
    ) async {
      final minutes = await pickMinutesOfDay(context, current);
      if (minutes != null) await change((p) => set(p, minutes));
    }

    String alertLabel(BreakAlert a) => switch (a) {
      BreakAlert.silent => l10n.settingsBreakAlertSilent,
      BreakAlert.vibrate => l10n.settingsBreakAlertVibrate,
      BreakAlert.sound => l10n.settingsBreakAlertSound,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(l10n.settingsBreakSection),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.settingsBreak),
          subtitle: Text(l10n.settingsBreakHint),
          value: prefs.breakReminderEnabled,
          onChanged: (v) => apply(prefs.copyWith(breakReminderEnabled: v)),
        ),
        Text(l10n.settingsBreakInterval, style: theme.textTheme.titleSmall),
        Wrap(
          spacing: AppSpacing.xs,
          children: [
            for (final m in breakIntervalOptions)
              ChoiceChip(
                label: Text(l10n.settingsBreakIntervalOption(m)),
                selected: prefs.breakIntervalMinutes == m,
                onSelected: (_) =>
                    change((p) => p.copyWith(breakIntervalMinutes: m)),
              ),
          ],
        ),
        Wrap(
          spacing: AppSpacing.xs,
          children: [
            OutlinedButton.icon(
              onPressed: () => pickTime(
                prefs.breakStartMinutes,
                (p, m) => p.copyWith(breakStartMinutes: m),
              ),
              icon: const Icon(Icons.schedule),
              label: Text(
                l10n.settingsBreakFrom(
                  formatMinutesOfDay(context, prefs.breakStartMinutes),
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => pickTime(
                prefs.breakEndMinutes,
                (p, m) => p.copyWith(breakEndMinutes: m),
              ),
              icon: const Icon(Icons.schedule),
              label: Text(
                l10n.settingsBreakTo(
                  formatMinutesOfDay(context, prefs.breakEndMinutes),
                ),
              ),
            ),
          ],
        ),
        Text(l10n.settingsBreakAlertLabel, style: theme.textTheme.titleSmall),
        Wrap(
          spacing: AppSpacing.xs,
          children: [
            for (final a in BreakAlert.values)
              ChoiceChip(
                label: Text(alertLabel(a)),
                selected: prefs.breakAlert == a,
                onSelected: (_) => change((p) => p.copyWith(breakAlert: a)),
              ),
          ],
        ),
        Text(
          l10n.settingsBreakAlertIosNote,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.appColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
