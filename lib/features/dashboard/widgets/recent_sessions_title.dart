import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/routes/app_pages.dart';
import '../../../models/session.dart';
import '../../../widgets/painters/mini_path_painter.dart';

class RecentSessionTile extends StatelessWidget {
  final Session session;

  const RecentSessionTile({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String dateStr = DateFormat('MMM d, h:mm a')
        .format(session.startTime);
    final double distKm = session.totalDistanceMeters / 1000;
    final int mins = (session.totalDurationSeconds / 60).round();

    return GestureDetector(
      onTap: () {
        AppPages.router.push('/session/${session.id}');
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomPaint(
                  painter: MiniPathPainter(
                    points: session.locationPoints,
                    pathColor: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateStr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${distKm.toStringAsFixed(2)} km  •  $mins mins  •  ${session.stopPoints.length} stops',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

