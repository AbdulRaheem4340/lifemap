import 'package:flutter/material.dart';

class PulsingLocationMarker extends StatefulWidget {
  const PulsingLocationMarker({super.key});

  @override
  State<PulsingLocationMarker> createState() => _PulsingLocationMarkerState();
}

class _PulsingLocationMarkerState extends State<PulsingLocationMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 1.0,
      end: 1.6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 32 * _animation.value,
              height: 32 * _animation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withValues(alpha: 0.25),
              ),
            ),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary,
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

