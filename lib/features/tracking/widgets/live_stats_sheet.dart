import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/clippers/curved_sheet_clipper.dart';
import '../../../widgets/painters/speed_gauge_painter.dart';
import '../tracking_controller.dart';

class LiveStatsSheet extends StatelessWidget {
  const LiveStatsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TrackingController>();
    final theme = Theme.of(context);

    return ClipPath(
      clipper: const CurvedSheetClipper(curveHeight: 18),
      child: Container(
        color: theme.colorScheme.surface,
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Obx(() {
          final double distKm = controller.totalDistanceMeters.value / 1000;
          final String durationStr = controller.formatDuration(
            controller.elapsedSeconds.value,
          );
          final double speed = controller.currentSpeedKmh.value;
          final double maxSpeed = controller.maxSpeedKmh.value;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 70,
                width: 140,
                child: CustomPaint(
                  painter: SpeedGaugePainter(
                    currentSpeed: speed,
                    maxSpeed: maxSpeed > 0 ? maxSpeed : 30.0,
                    trackColor: theme.colorScheme.outlineVariant,
                    gaugeColor: theme.colorScheme.primary,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            speed.toStringAsFixed(1),
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('km/h', style: theme.textTheme.labelSmall),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatTile(
                    label: 'Distance',
                    value: '${distKm.toStringAsFixed(2)} km',
                    icon: Icons.straighten_rounded,
                  ),
                  _StatTile(
                    label: 'Time',
                    value: durationStr,
                    icon: Icons.timer_rounded,
                  ),
                  _StatTile(
                    label: 'Stops',
                    value: '${controller.stopPoints.length}',
                    icon: Icons.pause_circle_rounded,
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

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

