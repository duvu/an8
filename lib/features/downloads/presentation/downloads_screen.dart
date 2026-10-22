import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../../../core/ui/async_value_view.dart';
import '../../library/application/library_providers.dart';

/// S11. Offline status and size per routine. Network download is not built
/// yet: there is no approved content host (see TRACKER T08).
class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final megabytes = NumberFormat('0.0', 'vi');
    return Scaffold(
      appBar: AppBar(title: Text(l10n.downloadsTitle)),
      body: AsyncValueView(
        value: ref.watch(libraryDataProvider),
        onRetry: () => ref.invalidate(libraryDataProvider),
        data: (data) => ListView(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          children: [
            Text(l10n.downloadsNote, style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.lg),
            for (final routine in data.catalog.routines)
              Builder(
                builder: (context) {
                  final ready = data.isAvailable(routine);
                  final size = megabytes.format(
                    data.catalog.bytesOf(routine) / (1024 * 1024),
                  );
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      ready
                          ? Icons.offline_pin_outlined
                          : Icons.cloud_off_outlined,
                      color: ready
                          ? theme.appColors.success
                          : theme.appColors.textSecondary,
                    ),
                    title: Text(routine.title),
                    subtitle: Text(
                      '${ready ? l10n.downloadsReady : l10n.downloadsMissing} · ${l10n.downloadsSize(size)}',
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
