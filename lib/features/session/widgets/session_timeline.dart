import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../widgets/painters/timeline_painter.dart';
import '../session_controller.dart';

class SessionTimeline extends StatelessWidget {
  const SessionTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SessionController>();
    final theme = Theme.of(context);

    return Obx(() {
      final s = controller.session.value;
      if (s == null) return const SizedBox.shrink();

      final String startTimeStr = DateFormat('h:mm a').format(s.startTime);
      final String endTimeStr = s.endTime != null
          ? DateFormat('h:mm a').format(s.endTime!)
          : 'Active';

      final totalItems = 2 + s.stopPoints.length;

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Journey Waypoints',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              CustomPaint(
                painter: JourneyTimelinePainter(
                  itemCount: totalItems,
                  lineColor: theme.colorScheme.outlineVariant,
                  startColor: Colors.green,
                  stopColor: theme.colorScheme.secondary,
                  endColor: Colors.red,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _WaypointRow(
                        title: 'Started Journey',
                        subtitle: controller.startAddress.value,
                        time: startTimeStr,
                        badgeColor: Colors.green,
                      ),

                      ...s.stopPoints.map((sp) {
                        final stopName =
                            controller.stopAddresses[sp.id] ??
                            'Stopped Location';
                        final stopTimeStr = DateFormat('h:mm a')
                            .format(sp.timestamp);

                        return _WaypointRow(
                          title: 'Stopped Here',
                          subtitle: stopName,
                          time: stopTimeStr,
                          badgeColor: theme.colorScheme.secondary,
                        );
                      }),

                      _WaypointRow(
                        title: 'Destination Reached',
                        subtitle: controller.endAddress.value,
                        time: endTimeStr,
                        badgeColor: Colors.red,
                      ),
                    ],
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

class _WaypointRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final Color badgeColor;

  const _WaypointRow({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              time,
              style: theme.textTheme.labelSmall?.copyWith(
                color: badgeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

