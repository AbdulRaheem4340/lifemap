import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../charts_controller.dart';

class ChartsSummaryStrip extends StatelessWidget {
  const ChartsSummaryStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ChartsController>();

    return Obx(() {
      return Row(
        children: [
          Expanded(
            child: _Tile(
              title: 'Distance',
              value: '${c.totalDistanceKm.value.toStringAsFixed(1)} km',
              icon: Icons.route_rounded,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _Tile(
              title: 'Time',
              value: c.formatDuration(c.totalDurationSeconds.value),
              icon: Icons.schedule_rounded,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _Tile(
              title: 'Moving',
              value: '${(c.movingRatio.value * 100).round()}%',
              icon: Icons.directions_walk_rounded,
            ),
          ),
        ],
      );
    });
  }
}

class _Tile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _Tile({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(value,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            Text(title, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}