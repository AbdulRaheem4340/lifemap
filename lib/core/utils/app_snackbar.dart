import 'package:flutter/material.dart';

import '../routes/app_pages.dart';

class AppSnackbar {
  AppSnackbar._();

  static void show(String title, String message, {bool isError = false}) {
    final context = AppPages.rootNavigatorKey.currentContext;
    if (context == null) return;

    final theme = Theme.of(context);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
        backgroundColor: isError
            ? theme.colorScheme.error
            : theme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

