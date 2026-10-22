import 'package:flutter/material.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/component_tokens.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../domain/day_almanac.dart';
import 'calendar_labels.dart';

/// Weekday header and the month as a table of whole weeks (Monday first).
/// Each cell shows the solar day with the lunar day under it.
class CalendarMonthGrid extends StatelessWidget {
  const CalendarMonthGrid({
    super.key,
    required this.month,
    required this.days,
    required this.selected,
    required this.today,
    required this.onSelect,
  });

  final DateTime month;
  final List<DayAlmanac> days;
  final DateTime selected;
  final DateTime today;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Table(
      children: [
        TableRow(
          children: [
            for (var weekday = 1; weekday <= 7; weekday++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Text(
                  l10n.weekdayShort(weekday),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: weekday == 7
                        ? theme.appColors.danger
                        : theme.appColors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
        for (var row = 0; row < days.length ~/ 7; row++)
          TableRow(
            children: [
              for (final almanac in days.sublist(row * 7, row * 7 + 7))
                _DayCell(
                  almanac: almanac,
                  inMonth: almanac.date.month == month.month,
                  isSelected: almanac.date == selected,
                  isToday: almanac.date == today,
                  onTap: () => onSelect(almanac.date),
                ),
            ],
          ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.almanac,
    required this.inMonth,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  final DayAlmanac almanac;
  final bool inMonth;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final lunar = almanac.lunar;
    final lunarText = lunar.day == 1
        ? l10n.calendarLunarMonthStart(lunar.day, lunar.month)
        : '${lunar.day}';
    final muted = inMonth ? colors.textPrimary : colors.textSecondary;
    final onFill = isSelected ? colors.onAccent : muted;
    final isSunday = almanac.date.weekday == DateTime.sunday;
    return Semantics(
      button: true,
      selected: isSelected,
      label: l10n.cellLabel(almanac),
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: IconButtonTokens.minTapTarget,
          ),
          margin: const EdgeInsets.all(CalendarTokens.cellMargin),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color: isSelected ? colors.accent : null,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: isToday && !isSelected
                ? Border.all(
                    color: colors.accent,
                    width: CalendarTokens.todayBorderWidth,
                  )
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${almanac.date.day}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isSelected
                        ? onFill
                        : isSunday && inMonth
                        ? colors.danger
                        : muted,
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  lunarText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isSelected ? onFill : colors.textSecondary,
                  ),
                ),
              ),
              // Hoàng đạo days carry a dot; the label says it in words too.
              Icon(
                almanac.isHoangDao ? Icons.circle : Icons.circle_outlined,
                size: CalendarTokens.markerSize,
                color: isSelected ? onFill : colors.accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
