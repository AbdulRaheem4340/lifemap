import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../settings_controller.dart';

class AppearanceSettingsGroup extends StatelessWidget {
  const AppearanceSettingsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();
    final theme = Theme.of(context);

    return Card(
      child: Column(
        children: [
          Obx(() {
            final isDark = controller.isDarkMode;
            return SwitchListTile(
              secondary: Icon(
                isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                color: theme.colorScheme.primary,
              ),
              title: const Text('Night Map View'),
              subtitle: Text(
                isDark
                    ? 'Satellite night dark mode active'
                    : 'Paper map light mode active',
              ),
              value: isDark,
              onChanged: (_) => controller.toggleTheme(),
            );
          }),
          const Divider(height: 1),

          Obx(() {
            final currentUnit = controller.selectedUnits.value;
            return ListTile(
              leading: Icon(
                Icons.straighten_rounded,
                color: theme.colorScheme.primary,
              ),
              title: const Text('Distance Units'),
              subtitle: Text('Currently set to ${currentUnit.toUpperCase()}'),
              trailing: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'km', label: Text('KM')),
                  ButtonSegment(value: 'miles', label: Text('MI')),
                ],
                selected: {currentUnit},
                onSelectionChanged: (val) => controller.setUnits(val.first),
              ),
            );
          }),
        ],
      ),
    );
  }
}

