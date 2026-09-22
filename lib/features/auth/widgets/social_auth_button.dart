import 'package:flutter/material.dart';

class SocialAuthButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SocialAuthButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      icon: Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            'G',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ),
      label: const Text('Continue with Google'),
    );
  }
}