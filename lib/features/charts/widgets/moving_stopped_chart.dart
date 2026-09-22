import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../charts_controller.dart';

class MovingStoppedChart extends StatelessWidget {
  const MovingStoppedChart({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ChartsController>();
    final theme = Theme.of(context);

    return Obx(() {
      final moving = c.movingRatio.value.clamp(0.0, 1.0);
      final stopped = 1.0 - moving;

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                width: 110,
                height: 110,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 28,
                    sections: [
                      PieChartSectionData(
                        value: moving <= 0 && stopped <= 0 ? 1 : moving * 100,
                        color: theme.colorScheme.primary,
                        radius: 18,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: moving <= 0 && stopped <= 0 ? 0 : stopped * 100,
                        color: theme.colorScheme.secondary,
                        radius: 18,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time Split',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _Legend(
                      color: theme.colorScheme.primary,
                      label: 'Moving',
                      value: '${(moving * 100).round()}%',
                    ),
                    const SizedBox(height: 8),
                    _Legend(
                      color: theme.colorScheme.secondary,
                      label: 'Stopped',
                      value: '${(stopped * 100).round()}%',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _Legend({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

