import 'dart:async';

import 'package:an_brand/an_brand.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/component_tokens.dart';
import '../../../app/theme/semantic_tokens.dart';

/// Opening screen: logo in the middle, slogan under it. Moves on by itself;
/// the router sends first-time users to onboarding. The native launch screen
/// shows the same picture (`scripts/build_launch_screen.py`), so there is no
/// fade-in: the hand-over from native to Flutter must not blink.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(SplashTokens.hold, () {
      if (mounted) context.go(AppRoutes.home);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  heightFactor: 1,
                  widthFactor: SplashTokens.lockupContentWidthFactor,
                  alignment: Alignment.centerLeft,
                  child: AnLockup(height: SplashTokens.lockupHeight),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  l10n.splashSlogan,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.appColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
