import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dashboard_controller.dart';

class TodayStatsCard extends StatelessWidget {
  const TodayStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          final double distKm = controller.todayDistanceKm.value;
          final String timeStr = controller.formatDuration(
            controller.todayDurationSeconds.value,
          );
          final int count = controller.todaySessionCount.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today's Activity",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _MetricItem(
                    label: 'Distance',
                    value: '${distKm.toStringAsFixed(1)} km',
                    icon: Icons.navigation_rounded,
                  ),
                  _MetricItem(
                    label: 'Duration',
                    value: timeStr,
                    icon: Icons.timer_rounded,
                  ),
                  _MetricItem(
                    label: 'Sessions',
                    value: '$count',
                    icon: Icons.map_rounded,
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, size: 22, color: theme.colorScheme.primary),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

