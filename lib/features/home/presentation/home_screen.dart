import 'package:an_brand/an_brand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/component_tokens.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../../../core/ui/async_value_view.dart';
import '../../catalog/presentation/demo_label.dart';
import '../../catalog/presentation/routine_card.dart';
import '../application/home_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const AnLockup(height: BrandTokens.appBarLockupHeight),
        actions: [
          IconButton(
            tooltip: l10n.calendarOpen,
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () => context.push(AppRoutes.calendar),
          ),
        ],
      ),
      body: AsyncValueView(
        value: ref.watch(homeDataProvider),
        onRetry: () => ref.invalidate(homeDataProvider),
        data: (home) {
          final featured = home.featured;
          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pageHorizontal,
              vertical: AppSpacing.lg,
            ),
            children: [
              Text(l10n.homeGreeting, style: theme.textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.lg),
              if (featured == null)
                Text(l10n.homeEmpty)
              else ...[
                if (home.catalog.isPreviewOnly(featured)) ...[
                  const DemoBanner(),
                  const SizedBox(height: AppSpacing.lg),
                ],
                RoutineCard(
                  catalog: home.catalog,
                  routine: featured,
                  onOpen: () => context.push(AppRoutes.routine(featured.id)),
                  onStart: () => context.push(AppRoutes.preflight(featured.id)),
                ),
              ],
              if (home.others.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xl),
                Text(l10n.homeOtherRoutines, style: theme.textTheme.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                for (final routine in home.others)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: RoutineCard(
                      catalog: home.catalog,
                      routine: routine,
                      onOpen: () => context.push(AppRoutes.routine(routine.id)),
                    ),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}
