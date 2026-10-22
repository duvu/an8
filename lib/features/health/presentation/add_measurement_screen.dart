import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/component_tokens.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../../../core/clock/clock_provider.dart';
import '../application/health_providers.dart';
import '../domain/health_assessment.dart';
import '../domain/health_metric.dart';
import '../domain/measurement_draft.dart';
import 'health_labels.dart';

/// Log one reading. Input is checked for typos only; after saving, a reading
/// outside the reference range shows the matching advice (never a diagnosis).
class AddMeasurementScreen extends ConsumerStatefulWidget {
  const AddMeasurementScreen({super.key, this.initialMetric});

  final HealthMetric? initialMetric;

  @override
  ConsumerState<AddMeasurementScreen> createState() =>
      _AddMeasurementScreenState();
}

class _AddMeasurementScreenState extends ConsumerState<AddMeasurementScreen> {
  late HealthMetric _metric = widget.initialMetric ?? healthMetricOrder.first;
  final _value = TextEditingController();
  final _note = TextEditingController();

  // Blood pressure: three number boxes in monitor order (systolic,
  // diastolic, pulse). Number pads differ in which separators they offer
  // (some have no "/"), so the boxes need none and move on by themselves.
  final _pressure = List.generate(3, (_) => TextEditingController());
  final _pressureFocus = List.generate(3, (_) => FocusNode());
  GlucoseTiming? _timing;
  bool _mgDl = false;
  late DateTime _measuredAt = ref.read(appClockProvider).now();
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _value.dispose();
    _note.dispose();
    for (final c in _pressure) {
      c.dispose();
    }
    for (final f in _pressureFocus) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = ref.read(appClockProvider).now();
    final date = await showDatePicker(
      context: context,
      initialDate: _measuredAt,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (date == null || !mounted) return;
    setState(
      () => _measuredAt = DateTime(
        date.year,
        date.month,
        date.day,
        _measuredAt.hour,
        _measuredAt.minute,
      ),
    );
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_measuredAt),
    );
    if (time == null || !mounted) return;
    setState(
      () => _measuredAt = DateTime(
        _measuredAt.year,
        _measuredAt.month,
        _measuredAt.day,
        time.hour,
        time.minute,
      ),
    );
  }

  MeasurementDraft _draft() => MeasurementDraft(
    metric: _metric,
    measuredAt: _measuredAt,
    valueText: _value.text,
    pressureTexts: [for (final c in _pressure) c.text],
    inMgDl: _mgDl,
    glucoseTiming: _timing,
    note: _note.text,
  );

  void _onPressureChanged(int box, String text) {
    final effect = pressureInputEffect(box, text);
    if (effect == null) return;
    for (final (i, part) in effect.fill.indexed) {
      _pressure[box + i].value = TextEditingValue(
        text: part,
        selection: TextSelection.collapsed(offset: part.length),
      );
    }
    _pressureFocus[effect.focus].requestFocus();
  }

  String _issueText(AppLocalizations l10n, DraftIssue issue) => switch (issue) {
    InvalidValue(:final metric, :final error) => l10n.errorText(error, metric),
    PressureFormat() => l10n.healthPressureFormat,
    PulseOutOfRange() => l10n.healthPulseRange(
      formatHealthNumber(HealthMetric.heartRate.min, 0),
      formatHealthNumber(HealthMetric.heartRate.max, 0),
    ),
    InTheFuture() => l10n.healthErrorFuture,
  };

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final draft = _draft();
    final issue = draft.check(ref.read(appClockProvider).now());
    setState(() => _error = issue == null ? null : _issueText(l10n, issue));
    if (issue != null || _saving) return;

    setState(() => _saving = true);
    final saved = await ref.read(healthActionsProvider).addDraft(draft);
    if (!mounted) return;
    final assessments = saved.map(assess).toList();
    final advice = [for (final a in assessments) ?l10n.reasonText(a.reason)];
    if (advice.isNotEmpty) {
      final urgent = assessments.any((a) => a.level == AssessmentLevel.urgent);
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(urgent ? l10n.healthUrgentTitle : l10n.statusOutside),
          content: SingleChildScrollView(child: Text(advice.join('\n\n'))),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.healthUrgentOk),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.healthSaved)));
    }
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.healthAddAction)),
      // Save is pinned in the body, not in bottomNavigationBar: the body is
      // resized above the keyboard, so Save stays visible while typing.
      body: Column(
        children: [
          Expanded(child: _form(l10n, theme)),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  child: Text(l10n.healthSave),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _form(AppLocalizations l10n, ThemeData theme) {
    final metric = _metric;
    const decimalKeyboard = TextInputType.numberWithOptions(decimal: true);
    final numbersOnly = [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))];
    Widget label(String text) => Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
      child: Text(text, style: theme.textTheme.titleMedium),
    );
    final unit = metric == HealthMetric.bloodGlucose && _mgDl
        ? l10n.unitMgDl
        : l10n.metricUnit(metric);
    final error = _error;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
      children: [
        if (widget.initialMetric == null) ...[
          label(l10n.healthMetricField),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final m in healthMetricOrder)
                ChoiceChip(
                  label: Text(l10n.metricName(m)),
                  selected: m == metric,
                  onSelected: (_) => setState(() {
                    _metric = m;
                    _error = null;
                  }),
                ),
            ],
          ),
        ] else
          Text(l10n.metricName(metric), style: theme.textTheme.headlineSmall),
        if (metric == HealthMetric.bloodPressure) ...[
          label(l10n.healthPressureField),
          _pressureBoxes(l10n),
          const SizedBox(height: AppSpacing.sm),
          if (error != null)
            Semantics(
              liveRegion: true,
              child: Text(
                error,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            )
          else
            Text(
              l10n.healthPressureHint,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ] else ...[
          label(l10n.healthValueField(unit)),
          TextField(
            controller: _value,
            autofocus: widget.initialMetric != null,
            keyboardType: decimalKeyboard,
            inputFormatters: numbersOnly,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
            decoration: InputDecoration(
              labelText: l10n.healthValueField(unit),
              errorText: error,
              errorMaxLines: 3,
            ),
          ),
        ],
        if (metric == HealthMetric.bloodGlucose) ...[
          label(l10n.healthUnitField),
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: false, label: Text(l10n.unitMmolL)),
              ButtonSegment(value: true, label: Text(l10n.unitMgDl)),
            ],
            selected: {_mgDl},
            onSelectionChanged: (s) => setState(() => _mgDl = s.single),
          ),
          label(l10n.healthTimingField),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final t in GlucoseTiming.values)
                ChoiceChip(
                  label: Text(l10n.glucoseTiming(t)),
                  selected: _timing == t,
                  onSelected: (_) => setState(() => _timing = t),
                ),
            ],
          ),
        ],
        label(
          l10n.healthMeasuredAt(
            MaterialLocalizations.of(context).formatShortDate(_measuredAt),
            MaterialLocalizations.of(context)
                .formatTimeOfDay(TimeOfDay.fromDateTime(_measuredAt)),
          ),
        ),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today),
              label: Text(l10n.healthChangeDate),
            ),
            OutlinedButton.icon(
              onPressed: _pickTime,
              icon: const Icon(Icons.schedule),
              label: Text(l10n.healthChangeTime),
            ),
          ],
        ),
        label(l10n.healthNoteField),
        TextField(
          controller: _note,
          maxLines: 2,
          decoration: InputDecoration(labelText: l10n.healthNoteField),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  /// Systolic, diastolic and pulse side by side like on the monitor;
  /// stacked when the screen is narrow or the text is large.
  Widget _pressureBoxes(AppLocalizations l10n) {
    final labels = [
      l10n.healthSystolicField,
      l10n.healthDiastolicField,
      l10n.healthPulseField,
    ];
    final last = _pressure.length - 1;
    final boxes = [
      for (var i = 0; i <= last; i++)
        TextField(
          controller: _pressure[i],
          focusNode: _pressureFocus[i],
          autofocus: i == 0 && widget.initialMetric != null,
          keyboardType: TextInputType.number,
          // Digits plus any separator key the number pad happens to have.
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9/ .,\-]')),
          ],
          textInputAction: i < last
              ? TextInputAction.next
              : TextInputAction.done,
          onChanged: (text) => _onPressureChanged(i, text),
          onSubmitted: (_) =>
              i < last ? _pressureFocus[i + 1].requestFocus() : _save(),
          decoration: InputDecoration(
            labelText: labels[i],
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final minWidth = MediaQuery.textScalerOf(context)
            .scale(HealthTokens.pressureBoxMinWidth);
        final inRow =
            constraints.maxWidth >=
            boxes.length * minWidth + last * AppSpacing.sm;
        if (!inRow) {
          return Column(
            children: [
              for (final (i, box) in boxes.indexed) ...[
                if (i > 0) const SizedBox(height: AppSpacing.md),
                box,
              ],
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (i, box) in boxes.indexed) ...[
              if (i > 0) const SizedBox(width: AppSpacing.sm),
              Expanded(child: box),
            ],
          ],
        );
      },
    );
  }
}
