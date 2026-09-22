import 'package:flutter/material.dart';
import '../../../widgets/clippers/diagonal_clipper.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double headerHeight = MediaQuery.of(context).size.height * 0.28;

    return ClipPath(
      clipper: const DiagonalClipper(cutHeight: 35),
      child: Container(
        height: headerHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primaryContainer,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.map_rounded,
                size: 40,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'LifeMap',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}