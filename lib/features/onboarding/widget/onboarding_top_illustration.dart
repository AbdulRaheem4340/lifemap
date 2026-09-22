import 'package:flutter/material.dart';

import '../../../widgets/clippers/wave_clipper.dart';

class OnboardingTopIllustration extends StatelessWidget {
  final IconData icon;

  const OnboardingTopIllustration({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double headerHeight = MediaQuery.of(context).size.height * 0.46;

    return SizedBox(
      height: headerHeight,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: const WaveClipper(ridgeShift: 0.11, peakDrift: -0.06),
              child: ColoredBox(
                color: theme.colorScheme.primary.withValues(alpha: 0.18),
              ),
            ),
          ),

          Positioned.fill(
            child: ClipPath(
              clipper: const WaveClipper(ridgeShift: 0.055, peakDrift: -0.03),
              child: ColoredBox(
                color: theme.colorScheme.primary.withValues(alpha: 0.38),
              ),
            ),
          ),

          const Positioned.fill(child: _ForegroundRidge()),

          Positioned.fill(
            child: Align(
              alignment: const Alignment(0, -0.22),
              child: _GlassIconBadge(icon: icon),
            ),
          ),
        ],
      ),
    );
  }
}

class _ForegroundRidge extends StatelessWidget {
  const _ForegroundRidge();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipPath(
      clipper: const WaveClipper(),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              Color.lerp(
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                    0.35,
                  ) ??
                  theme.colorScheme.primary,
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassIconBadge extends StatelessWidget {
  final IconData icon;

  const _GlassIconBadge({required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color onPrimary = theme.colorScheme.onPrimary;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: onPrimary.withValues(alpha: 0.10),
        border: Border.all(
          color: onPrimary.withValues(alpha: 0.22),
          width: 1.5,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onPrimary.withValues(alpha: 0.16),
          border: Border.all(
            color: onPrimary.withValues(alpha: 0.30),
            width: 1.5,
          ),
        ),
        child: Icon(icon, size: 64, color: onPrimary),
      ),
    );
  }
}

