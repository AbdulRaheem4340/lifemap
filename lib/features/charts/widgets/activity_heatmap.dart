import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/painters/heatmap_painter.dart';
import '../charts_controller.dart';

class ActivityHeatmap extends StatelessWidget {
  const ActivityHeatmap({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ChartsController>();
    final theme = Theme.of(context);

    return Obx(() {
      final grid = c.heatmap.toList();
      return Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Activity Heatmap',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'When you move during the week (Mon–Sun × hour)',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 180,
                width: double.infinity,
                child: grid.isEmpty
                    ? const Center(child: Text('No activity yet'))
                    : CustomPaint(
                        painter: HeatmapPainter(
                          values: grid,
                          baseColor: theme.colorScheme.primary,
                          emptyColor: theme.colorScheme.outline,
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

