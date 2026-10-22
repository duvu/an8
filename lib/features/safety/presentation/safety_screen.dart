import 'package:flutter/material.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/semantic_tokens.dart';

/// S12. General safety rules; no diagnosis or medical claims.
class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final rules = [
      l10n.safetyRuleSpace,
      l10n.safetyRuleGentle,
      l10n.safetyRuleNeck,
      l10n.stopWarning,
      l10n.safetyEmergency,
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.safetyTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
        children: [
          Text(l10n.safetyIntro, style: theme.textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.lg),
          for (final rule in rules)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.check, color: theme.appColors.accent),
              title: Text(rule),
            ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: () => Navigator.of(context).maybePop(),
            child: Text(l10n.safetyBack),
          ),
        ],
      ),
    );
  }
}
