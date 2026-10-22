import 'package:flutter/material.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../domain/cultural_content.dart';

/// "Tìm hiểu" for one exercise: meaning, what to notice, sources.
class ExerciseLearnSection extends StatelessWidget {
  const ExerciseLearnSection({
    super.key,
    required this.story,
    required this.references,
  });

  final ExerciseStory story;
  final List<Reference> references;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Section(
      header: l10n.learnHeader,
      label: story.angle,
      references: references,
      children: [
        _Paragraph(title: l10n.learnMeaning, text: story.meaning),
        _Paragraph(title: l10n.learnAwareness, text: story.movementAwareness),
        if (story.historicalNote case final note?)
          _Paragraph(title: l10n.learnNote, text: note),
      ],
    );
  }
}

/// History and culture of one practice system.
class SystemProfileSection extends StatelessWidget {
  const SystemProfileSection({
    super.key,
    required this.profile,
    required this.references,
  });

  final SystemProfile profile;
  final List<Reference> references;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Section(
      header: l10n.learnSystemHeader,
      label: profile.originLabel,
      references: references,
      children: [
        _Paragraph(title: l10n.learnHistory, text: profile.history),
        _Paragraph(title: l10n.learnContext, text: profile.culturalContext),
        _Paragraph(title: l10n.learnSpirit, text: profile.interpretiveFrame),
        if (profile.cautions.isNotEmpty)
          _Paragraph(
            title: l10n.learnReadingCautions,
            text: profile.cautions.map((c) => '• $c').join('\n'),
          ),
      ],
    );
  }
}

/// Footnote every learn surface carries (D17).
class LearnDisclaimer extends StatelessWidget {
  const LearnDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      AppLocalizations.of(context).learnDisclaimer,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.appColors.textSecondary,
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.header,
    required this.label,
    required this.references,
    required this.children,
  });

  final String header;
  final String label;
  final List<Reference> references;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final secondary = theme.textTheme.bodyMedium?.copyWith(
      color: theme.appColors.textSecondary,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text(header, style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: secondary),
        ...children,
        if (references.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Text(l10n.learnSources, style: theme.textTheme.titleMedium),
          for (final r in references)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: SelectableText('${r.title}\n${r.url}', style: secondary),
            ),
        ],
        const SizedBox(height: AppSpacing.md),
        const LearnDisclaimer(),
      ],
    );
  }
}

class _Paragraph extends StatelessWidget {
  const _Paragraph({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(text, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
