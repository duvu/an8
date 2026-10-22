import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/semantic_tokens.dart';
import 'break_reminder_section.dart';
import 'daily_reminder_section.dart';
import 'health_data_section.dart';
import 'practice_settings_section.dart';
import 'settings_widgets.dart';

/// S10. Each section owns its settings; changes apply and persist immediately.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pageHorizontal,
        ),
        children: [
          const PracticeSettingsSection(),
          const DailyReminderSection(),
          const BreakReminderSection(),
          const HealthDataSection(),
          SettingsSectionTitle(l10n.settingsMoreSection),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.health_and_safety_outlined),
            title: Text(l10n.settingsSafety),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.safety),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.download_done_outlined),
            title: Text(l10n.settingsDownloads),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.downloads),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.lock_outline),
            title: Text(l10n.settingsPrivacy),
            subtitle: Text(l10n.settingsPrivacyBody),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
