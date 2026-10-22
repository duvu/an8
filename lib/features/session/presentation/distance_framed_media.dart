import 'package:flutter/material.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/component_tokens.dart';
import '../../../app/theme/semantic_tokens.dart';
import '../application/session_controller.dart';
import '../domain/session_machine.dart';
import '../../catalog/presentation/exercise_image.dart';
import 'player_chip.dart';

/// The exercise image inside a progress frame that empties clockwise as the
/// step runs out. A rounded square, not a circle, so the body is never cropped.
class DistanceFramedMedia extends StatelessWidget {
  const DistanceFramedMedia({
    super.key,
    required this.view,
    required this.ending,
    required this.reduceMotion,
    required this.side,
  });

  final SessionViewState view;
  final bool ending;
  final bool reduceMotion;
  final double side;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).appColors;
    final snapshot = view.snapshot;
    final step = view.currentStep;
    final frame = step.frameAt(view.stepOffset);
    final remainingFraction =
        (view.stepRemaining.inMilliseconds / step.duration.inMilliseconds)
            .clamp(0.0, 1.0);
    final active =
        snapshot.status == SessionStatus.playing ||
        snapshot.status == SessionStatus.countdown;
    final color = ending ? colors.warning : colors.accent;
    const inset =
        DistanceViewTokens.frameStrokeWidth + DistanceViewTokens.frameGap;

    return SizedBox.square(
      dimension: side,
      child: _BreathingGlow(
        color: color,
        enabled: active && !reduceMotion,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: remainingFraction),
          duration: reduceMotion
              ? Duration.zero
              : SessionController.refreshInterval,
          builder: (context, value, child) => CustomPaint(
            foregroundPainter: _FramePainter(
              fraction: value,
              color: color,
              trackColor: colors.border,
            ),
            child: child,
          ),
          child: Padding(
            padding: const EdgeInsets.all(inset),
            child: Stack(
              children: [
                AnimatedSwitcher(
                  duration: reduceMotion
                      ? Duration.zero
                      : MotionTokens.frameCrossfade,
                  child: ExerciseImage(
                    key: ValueKey(frame.framePath),
                    path: frame.framePath,
                    semanticLabel: frame.instruction,
                    aspectRatio: 1,
                  ),
                ),
                if (step.exercise.demoOnly)
                  Positioned(
                    left: AppSpacing.sm,
                    top: AppSpacing.sm,
                    child: PlayerChip(text: l10n.playerDemoMediaNotice),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FramePainter extends CustomPainter {
  const _FramePainter({
    required this.fraction,
    required this.color,
    required this.trackColor,
  });

  final double fraction;
  final Color color;
  final Color trackColor;

  /// Rounded square starting at 12 o'clock, clockwise.
  static Path _outline(Rect r, double radius) => Path()
    ..moveTo(r.center.dx, r.top)
    ..lineTo(r.right - radius, r.top)
    ..arcToPoint(
      Offset(r.right, r.top + radius),
      radius: Radius.circular(radius),
    )
    ..lineTo(r.right, r.bottom - radius)
    ..arcToPoint(
      Offset(r.right - radius, r.bottom),
      radius: Radius.circular(radius),
    )
    ..lineTo(r.left + radius, r.bottom)
    ..arcToPoint(
      Offset(r.left, r.bottom - radius),
      radius: Radius.circular(radius),
    )
    ..lineTo(r.left, r.top + radius)
    ..arcToPoint(
      Offset(r.left + radius, r.top),
      radius: Radius.circular(radius),
    )
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = DistanceViewTokens.frameStrokeWidth;
    final outline = _outline(
      (Offset.zero & size).deflate(stroke / 2),
      DistanceViewTokens.frameRadius,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(outline, paint..color = trackColor);
    if (fraction <= 0) return;
    final metric = outline.computeMetrics().first;
    canvas.drawPath(
      metric.extractPath(0, metric.length * fraction),
      paint..color = color,
    );
  }

  @override
  bool shouldRepaint(_FramePainter old) =>
      old.fraction != fraction ||
      old.color != color ||
      old.trackColor != trackColor;
}

/// Slow pulsing halo behind the ring. Runs only while [enabled]; never when the
/// user asked for reduced motion.
class _BreathingGlow extends StatefulWidget {
  const _BreathingGlow({
    required this.color,
    required this.enabled,
    required this.child,
  });

  final Color color;
  final bool enabled;
  final Widget child;

  @override
  State<_BreathingGlow> createState() => _BreathingGlowState();
}

class _BreathingGlowState extends State<_BreathingGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: DistanceViewTokens.pulsePeriod,
  );

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(_BreathingGlow old) {
    super.didUpdateWidget(old);
    if (old.enabled != widget.enabled) _sync();
  }

  void _sync() {
    if (widget.enabled) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    child: widget.child,
    builder: (context, child) {
      final t = Curves.easeInOut.transform(_controller.value);
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(DistanceViewTokens.frameRadius),
          ),
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.08 + 0.2 * t),
              blurRadius: AppSpacing.xl + AppSpacing.lg * t,
              spreadRadius: AppSpacing.xs * t,
            ),
          ],
        ),
        child: child,
      );
    },
  );
}
