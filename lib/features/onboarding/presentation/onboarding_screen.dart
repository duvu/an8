import 'package:an_brand/an_brand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/component_tokens.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../../catalog/application/catalog_providers.dart';
import '../../catalog/domain/catalog_models.dart';
import '../../catalog/presentation/catalog_labels.dart';
import '../../settings/application/preferences_controller.dart';

/// S01. Value + safety, then optional goal/position. No personal or health data.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  bool _showPreferences = false;
  String? _goal;
  BodyPosition? _position;

  Future<void> _finish({required bool savePreferences}) async {
    await ref
        .read(preferencesProvider.notifier)
        .update(
          (p) => p.copyWith(
            onboardingCompleted: true,
            goalTag: savePreferences ? () => _goal : null,
            position: savePreferences ? () => _position : null,
          ),
        );
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tags = {
      for (final r
          in ref.watch(catalogProvider).value?.routines ?? const <Routine>[])
        ...r.tags,
    };
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          children: [
            const SizedBox(height: AppSpacing.xl),
            const Align(
              alignment: Alignment.centerLeft,
              child: AnLockup(height: BrandTokens.onboardingLockupHeight),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (!_showPreferences) ...[
              Text(
                l10n.onboardingValueTitle,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.onboardingValueBody, style: theme.textTheme.bodyLarge),
              const SizedBox(height: AppSpacing.lg),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.health_and_safety_outlined,
                  color: theme.appColors.accent,
                ),
                title: Text(l10n.onboardingSafetyNotice),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: () => setState(() => _showPreferences = true),
                child: Text(l10n.onboardingContinue),
              ),
            ] else ...[
              Text(
                l10n.onboardingPrefsTitle,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.onboardingGoal, style: theme.textTheme.titleSmall),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final t in tags)
                    ChoiceChip(
                      label: Text(l10n.tag(t)),
                      selected: _goal == t,
                      onSelected: (on) => setState(() => _goal = on ? t : null),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.onboardingPosition, style: theme.textTheme.titleSmall),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final (value, label) in [
                    (BodyPosition.seated, l10n.positionSeated),
                    (BodyPosition.standing, l10n.positionStanding),
                    (null, l10n.onboardingPositionAny),
                  ])
                    ChoiceChip(
                      label: Text(label),
                      selected: _position == value,
                      onSelected: (_) => setState(() => _position = value),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: () => _finish(savePreferences: true),
                child: Text(l10n.onboardingDone),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () => _finish(savePreferences: false),
              child: Text(l10n.onboardingSkip),
            ),
          ],
        ),
      ),
    );
  }
}
