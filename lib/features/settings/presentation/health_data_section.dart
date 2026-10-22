import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../../health/application/health_providers.dart';
import '../application/preferences_controller.dart';
import 'settings_widgets.dart';

/// D18 retention: erase every health reading and withdraw consent. Shown only
/// once the user has agreed to keep health data.
class HealthDataSection extends ConsumerWidget {
  const HealthDataSection({super.key});

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.settingsHealthDeleteAllConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.healthCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.healthDeleteConfirmAction),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(healthActionsProvider).deleteAllAndWithdraw();
    messenger.showSnackBar(SnackBar(content: Text(l10n.settingsHealthDeleted)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(preferencesProvider.select((p) => p.healthConsent))) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(l10n.settingsHealthSection),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            Icons.delete_forever_outlined,
            color: Theme.of(context).appColors.danger,
          ),
          title: Text(l10n.settingsHealthDeleteAll),
          subtitle: Text(l10n.settingsHealthDeleteAllHint),
          onTap: () => _confirmDelete(context, ref),
        ),
      ],
    );
  }
}
