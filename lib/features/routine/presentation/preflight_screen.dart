import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/semantic_tokens.dart';

class PreflightScreen extends StatelessWidget {
  const PreflightScreen({super.key, required this.routineId});

  final String routineId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final items = [
      (Icons.open_with, l10n.preflightSpace),
      (Icons.chair_outlined, l10n.preflightChair),
      (Icons.self_improvement, l10n.preflightComfort),
      (Icons.warning_amber_rounded, l10n.stopWarning),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.preflightTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
        children: [
          for (final (icon, text) in items)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(icon, color: theme.appColors.accent),
              title: Text(text),
            ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => context.push(AppRoutes.safety),
            child: Text(l10n.safetyLink),
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: () =>
                context.pushReplacement(AppRoutes.session(routineId)),
            child: Text(l10n.preflightConfirm),
          ),
        ],
      ),
    );
  }
}
