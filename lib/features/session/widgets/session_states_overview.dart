import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../session_controller.dart';

class SessionStatsOverview extends StatelessWidget {
  const SessionStatsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SessionController>();
    final theme = Theme.of(context);

    return Obx(() {
      final s = controller.session.value;
      if (s == null) return const SizedBox.shrink();

      final double distKm = s.totalDistanceMeters / 1000;
      final String durationStr = controller.formatDuration(
        s.totalDurationSeconds,
      );
      final double avgSpeed = s.averageSpeed;
      final double maxSpeed = s.maxSpeed;

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Journey Metrics',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Distance',
                      value: '${distKm.toStringAsFixed(2)} km',
                      icon: Icons.straighten_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Duration',
                      value: durationStr,
                      icon: Icons.timer_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Avg Speed',
                      value: '${avgSpeed.toStringAsFixed(1)} km/h',
                      icon: Icons.speed_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Max Speed',
                      value: '${maxSpeed.toStringAsFixed(1)} km/h',
                      icon: Icons.flash_on_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(label, style: theme.textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}

