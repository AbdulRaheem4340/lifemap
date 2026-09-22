import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifemap/features/dashboard/widgets/recent_sessions_title.dart';
import 'package:lifemap/features/session/widgets/session_history_controller.dart';


class SessionHistoryScreen extends StatelessWidget {
  const SessionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SessionHistoryController());
    controller.loadHistory();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('All Journeys')),
      body: Obx(() {
        final sessions = controller.allSessions;

        if (sessions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.explore_off_rounded,
                  size: 48,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(height: 12),
                Text(
                  'No Recorded Journeys',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            return RecentSessionTile(session: sessions[index]);
          },
        );
      }),
    );
  }
}

