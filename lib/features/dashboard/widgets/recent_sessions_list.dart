import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifemap/features/dashboard/widgets/recent_sessions_title.dart';
import '../../../core/routes/app_pages.dart';
import '../../../core/routes/app_routes.dart';
import '../dashboard_controller.dart';

class RecentSessionsList extends StatelessWidget {
  const RecentSessionsList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    final theme = Theme.of(context);

    return Obx(() {
      final sessions = controller.recentSessions;
      final totalCount = controller.totalSessionCount.value;

      if (sessions.isEmpty) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(
                  Icons.explore_off_rounded,
                  size: 40,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(height: 12),
                Text(
                  'No Journeys Recorded Yet',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap the START button above to log your first path.',
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Journeys',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (totalCount > 5)
                TextButton(
                  onPressed: () {
                    AppPages.router.push(AppRoutes.history);
                  },
                  child: Text('See All ($totalCount)'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              return RecentSessionTile(session: sessions[index]);
            },
          ),
        ],
      );
    });
  }
}