import 'package:flutter/material.dart';

import '../../../widgets/clippers/profile_header_clipper.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        ClipPath(
          clipper: const ProfileHeaderClipper(curveDepth: 28),
          child: Container(
            height: 160,
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
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Text(
                    'Explorer Profile',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'explorer@lifemap.app',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          bottom: -28,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 36,
              backgroundColor: theme.colorScheme.primary,
              child: Icon(
                Icons.person_rounded,
                size: 40,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

