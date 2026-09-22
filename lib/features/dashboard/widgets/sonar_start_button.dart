import 'package:flutter/material.dart';
import 'package:lifemap/core/routes/app_pages.dart';
import 'package:lifemap/services/notification_service.dart';

import '../../../core/routes/app_routes.dart';

class SonarStartButton extends StatefulWidget {
  const SonarStartButton({super.key});

  @override
  State<SonarStartButton> createState() => _SonarStartButtonState();
}

class _SonarStartButtonState extends State<SonarStartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _rippleAnimation,
      builder: (context, child) {
        final double val = _rippleAnimation.value;

        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 72 + (36 * val),
              height: 72 + (36 * val),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withValues(
                  alpha: 0.25 * (1 - val),
                ),
              ),
            ),

            GestureDetector(
              onTap: () async {
                await NotificationService.to.requestPermission();
                AppPages.router.push(AppRoutes.tracking);
              },
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.4),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_arrow_rounded,
                      size: 32,
                      color: theme.colorScheme.onPrimary,
                    ),
                    Text(
                      'START',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

