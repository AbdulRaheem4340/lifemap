import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../settings_controller.dart';

class DataManagementGroup extends StatelessWidget {
  const DataManagementGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();
    final theme = Theme.of(context);

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.download_rounded,
              color: theme.colorScheme.primary,
            ),
            title: const Text('Export Journey History'),
            subtitle: const Text('Copy all saved session data as JSON'),
            trailing: const Icon(Icons.content_copy_rounded, size: 18),
            onTap: controller.exportData,
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.delete_forever_rounded,
              color: theme.colorScheme.error,
            ),
            title: Text(
              'Clear Local History',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            subtitle: const Text(
              'Delete all saved sessions from local Hive memory',
            ),
            onTap: () => controller.clearLocalData(context),
          ),
        ],
      ),
    );
  }
}

