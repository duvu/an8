import 'package:flutter/material.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../domain/day_activities.dart';
import '../domain/day_almanac.dart';
import '../domain/lunar_mansions.dart';
import 'calendar_labels.dart';

/// Everything the almanac says about one day, in sections: dates, day
/// quality, giờ hoàng đạo and xuất hành.
class DayDetailView extends StatelessWidget {
  const DayDetailView({super.key, required this.almanac});

  final DayAlmanac almanac;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final a = almanac;
    final secondary = theme.textTheme.bodyMedium?.copyWith(
      color: theme.appColors.textSecondary,
    );

    Widget heading(String text) => Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.sm),
      child: Text(text, style: theme.textTheme.titleLarge),
    );
    Widget line(String text, {TextStyle? style}) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(text, style: style ?? theme.textTheme.bodyLarge),
    );

    final lunar = a.lunar;
    final ratingColor = switch (a.rating) {
      DayRating.good => theme.appColors.success,
      DayRating.neutral => theme.appColors.warning,
      DayRating.bad => theme.appColors.danger,
    };
    final ratingIcon = switch (a.rating) {
      DayRating.good => Icons.check_circle_outline,
      DayRating.neutral => Icons.remove_circle_outline,
      DayRating.bad => Icons.warning_amber_outlined,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading(l10n.calendarSectionDate),
        Semantics(
          header: true,
          child: Text(
            l10n.calendarSelectedDate(
              l10n.weekdayFull(a.date.weekday),
              a.date.day,
              a.date.month,
              a.date.year,
            ),
            style: theme.textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        line(
          l10n.calendarLunarDate(
            lunar.day,
            lunar.month,
            lunar.isLeapMonth ? l10n.calendarLeapSuffix : '',
            a.yearCanChi.name,
          ),
        ),
        line(
          l10n.calendarCanChiLine(
            a.dayCanChi.name,
            a.monthCanChi.name,
            a.yearCanChi.name,
          ),
        ),
        line(
          a.termStartsToday
              ? l10n.calendarSolarTermStarts(a.solarTerm)
              : l10n.calendarSolarTerm(a.solarTerm),
        ),
        if (a.isFirstOfLunarMonth) line(l10n.calendarFirstDay),
        if (a.isFullMoon) line(l10n.calendarFullMoon),

        heading(l10n.calendarSectionQuality),
        Row(
          children: [
            Icon(ratingIcon, color: ratingColor),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                l10n.ratingText(a.rating),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: ratingColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        line(l10n.calendarGodLine(l10n.dayKind(a), a.godName)),
        line(l10n.calendarTruc(a.trucName, a.trucDetail.note)),
        line(l10n.calendarRatingNote, style: secondary),

        heading(l10n.calendarSectionActivities),
        for (final advice in adviceFor(a))
          _ActivityRow(advice: advice, almanac: a),
        line(l10n.calendarActivitiesNote, style: secondary),

        heading(l10n.calendarSectionMansion),
        Semantics(
          header: true,
          child: Text(
            l10n.calendarMansionLine(
              a.mansionDetail.name,
              a.mansionDetail.element,
              a.mansionDetail.animal,
            ),
            style: theme.textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Icon(
              switch (a.mansionDetail.level) {
                MansionLevel.kiet => Icons.check_circle_outline,
                MansionLevel.binh => Icons.remove_circle_outline,
                MansionLevel.hung => Icons.warning_amber_outlined,
              },
              color: switch (a.mansionDetail.level) {
                MansionLevel.kiet => theme.appColors.success,
                MansionLevel.binh => theme.appColors.warning,
                MansionLevel.hung => theme.appColors.danger,
              },
            ),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                l10n.mansionLevelText(a.mansionDetail.level),
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        line(l10n.calendarMansionFavorable(a.mansionDetail.favorable)),
        line(l10n.calendarMansionAvoid(a.mansionDetail.avoid)),

        heading(l10n.calendarSectionHours),
        for (final h in a.hoangDaoHours)
          line(
            l10n.calendarHourLine(
              h.name,
              hourText(h.startHour),
              hourText(h.endHour),
              h.godName,
            ),
          ),

        heading(l10n.calendarSectionDeparture),
        line(
          l10n.calendarDepartureDay(
            a.lucDieuDayInfo.name,
            a.lucDieuDayInfo.note,
          ),
        ),
        line(l10n.calendarHyThan(a.hyThan)),
        line(l10n.calendarTaiThan(a.taiThan)),
        const SizedBox(height: AppSpacing.sm),
        Text(l10n.calendarDepartureHours, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        if (a.departureHours.isEmpty)
          line(l10n.calendarNoDepartureHours)
        else
          for (final h in a.departureHours)
            line(
              l10n.calendarHourLine(
                h.name,
                hourText(h.startHour),
                hourText(h.endHour),
                lucDieuInfoAt(h.lucDieu).name,
              ),
            ),
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Text(l10n.calendarAllHours),
          children: [
            for (final h in a.hours)
              Align(
                alignment: Alignment.centerLeft,
                child: line(
                  l10n.calendarHourDetail(
                    h.name,
                    hourText(h.startHour),
                    hourText(h.endHour),
                    h.isHoangDao
                        ? l10n.calendarHourHoangDao
                        : l10n.calendarHourHacDao,
                    lucDieuInfoAt(h.lucDieu).name,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),
        Text(l10n.calendarDisclaimer, style: secondary),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

/// One activity with its verdict (icon and words) and the reasons behind it.
class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.advice, required this.almanac});

  final ActivityAdvice advice;
  final DayAlmanac almanac;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final (icon, color) = switch (advice.verdict) {
      Verdict.favorable => (Icons.check_circle_outline, colors.success),
      Verdict.neutral => (Icons.remove_circle_outline, colors.warning),
      Verdict.unfavorable => (Icons.block, colors.danger),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: MergeSemantics(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.calendarActivityRow(
                      l10n.activityName(advice.activity),
                      l10n.verdictText(advice.verdict),
                    ),
                    style: theme.textTheme.titleMedium,
                  ),
                  if (advice.evidence.isEmpty)
                    Text(
                      l10n.calendarNoEvidence,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                      ),
                    )
                  else
                    for (final e in advice.evidence)
                      Text(
                        l10n.evidenceText(e, almanac),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
