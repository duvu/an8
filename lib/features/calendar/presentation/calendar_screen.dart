import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/component_tokens.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../../../core/clock/clock_provider.dart';
import '../application/calendar_controller.dart';
import '../domain/day_almanac.dart';
import 'calendar_month_grid.dart';
import 'day_detail_view.dart';

/// Lịch vạn niên: solar and lunar month, with the selected day's almanac
/// (day quality, giờ hoàng đạo, xuất hành) below.
class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  Future<void> _pickDate(
    BuildContext context,
    CalendarController controller,
    DateTime current,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: firstSupportedDate,
      lastDate: lastSupportedDate,
    );
    if (picked != null) controller.select(picked);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(calendarControllerProvider);
    final controller = ref.read(calendarControllerProvider.notifier);
    final now = ref.watch(appClockProvider).now();
    final today = DateTime(now.year, now.month, now.day);
    final days = ref.watch(monthAlmanacProvider(state.month));
    final selected = days.firstWhere(
      (d) => d.date == state.selected,
      orElse: () => almanacFor(state.selected),
    );
    final monthYear = almanacFor(
      DateTime(state.month.year, state.month.month, 15),
    ).yearCanChi.name;

    Widget pad(Widget child) => Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontal,
      ),
      child: child,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.calendarTitle),
        actions: [
          IconButton(
            tooltip: l10n.calendarPickDate,
            icon: const Icon(Icons.edit_calendar_outlined),
            onPressed: () => _pickDate(context, controller, state.selected),
          ),
          TextButton(
            onPressed: controller.goToToday,
            child: Text(l10n.calendarToday),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        children: [
          // The grid uses the full width: seven cells must still be >= 48dp.
          pad(
            Row(
              children: [
                IconButton(
                  tooltip: l10n.calendarPrevMonth,
                  constraints: const BoxConstraints(
                    minWidth: IconButtonTokens.minTapTarget,
                    minHeight: IconButtonTokens.minTapTarget,
                  ),
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => controller.moveMonth(-1),
                ),
                Expanded(
                  child: Semantics(
                    liveRegion: true,
                    child: Column(
                      children: [
                        Text(
                          l10n.calendarMonthTitle(
                            state.month.month,
                            state.month.year,
                          ),
                          style: theme.textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          l10n.calendarMonthSubtitle(monthYear),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.appColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  tooltip: l10n.calendarNextMonth,
                  constraints: const BoxConstraints(
                    minWidth: IconButtonTokens.minTapTarget,
                    minHeight: IconButtonTokens.minTapTarget,
                  ),
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => controller.moveMonth(1),
                ),
              ],
            ),
          ),
          CalendarMonthGrid(
            month: state.month,
            days: days,
            selected: state.selected,
            today: today,
            onSelect: controller.select,
          ),
          pad(
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                l10n.calendarLegend,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.appColors.textSecondary,
                ),
              ),
            ),
          ),
          pad(DayDetailView(almanac: selected)),
        ],
      ),
    );
  }
}
