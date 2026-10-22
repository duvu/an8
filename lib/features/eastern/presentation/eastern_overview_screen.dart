import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/component_tokens.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../../../core/ui/async_value_view.dart';
import '../application/eastern_providers.dart';
import 'eastern_widgets.dart';

/// One overview board, full screen with pinch-to-zoom (8 forms per board are
/// too small to read otherwise). Reference only, never instruction (D21).
class EasternOverviewScreen extends ConsumerWidget {
  const EasternOverviewScreen({
    super.key,
    required this.slug,
    required this.boardId,
  });

  final String slug;
  final String boardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.easternTitle)),
      body: AsyncValueView(
        value: ref.watch(easternSystemsProvider),
        onRetry: () => ref.invalidate(easternSystemsProvider),
        data: (systems) {
          final system = systems.where((s) => s.slug == slug).firstOrNull;
          final board = system?.overviewBoards
              .where((b) => b.id == boardId)
              .firstOrNull;
          if (system == null || board == null) {
            return Center(child: Text(l10n.notFound));
          }
          return LayoutBuilder(
            builder: (context, constraints) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // At large text sizes the header scrolls instead of
                // squeezing the board off screen.
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight / 2,
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(board.title, style: theme.textTheme.headlineSmall),
                        Text(
                          system.titleVi,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.appColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        EasternNotice(text: l10n.easternOverviewNotice),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InteractiveViewer(
                    maxScale: EasternTokens.overviewMaxZoom,
                    child: Image.asset(
                      board.assetKey,
                      fit: BoxFit.contain,
                      semanticLabel: l10n.easternOverviewLabel(
                        system.titleVi,
                        board.title,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
