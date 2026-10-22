import 'package:flutter/material.dart';

import '../../../app/theme/semantic_tokens.dart';

/// Heading that starts a group of settings.
class SettingsSectionTitle extends StatelessWidget {
  const SettingsSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.xs),
    child: Text(title, style: Theme.of(context).textTheme.titleMedium),
  );
}

String formatMinutesOfDay(BuildContext context, int minutes) =>
    MaterialLocalizations.of(context)
        .formatTimeOfDay(TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60));

/// Time picker over minutes after midnight; null when dismissed.
Future<int?> pickMinutesOfDay(BuildContext context, int current) async {
  final picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: current ~/ 60, minute: current % 60),
  );
  return picked == null ? null : picked.hour * 60 + picked.minute;
}
