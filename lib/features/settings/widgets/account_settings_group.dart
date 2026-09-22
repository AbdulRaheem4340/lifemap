import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../settings_controller.dart';

class AccountSettingsGroup extends StatelessWidget {
  const AccountSettingsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();
    final theme = Theme.of(context);

    return Column(
      children: [
        Card(
          child: ListTile(
            leading: Icon(Icons.logout_rounded, color: theme.colorScheme.error),
            title: Text(
              'Log Out',
              style: TextStyle(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => controller.logout(context),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'LifeMap v1.0.0',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
        Text(
          'Your life, mapped and understood.',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }
}

