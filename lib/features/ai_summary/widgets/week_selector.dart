import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ai_controller.dart';

class WeekSelector extends StatelessWidget {
  const WeekSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AIController>();
    final theme = Theme.of(context);

    return Obx(() {
      return Row(
        children: [
          IconButton(
            tooltip: 'Previous week',
            onPressed: c.previousWeek,
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          Expanded(
            child: Column(
              children: [
                Text('Week of', style: theme.textTheme.labelSmall),
                Text(
                  c.weekLabel,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Next week',
            onPressed: c.nextWeek,
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      );
    });
  }
}

