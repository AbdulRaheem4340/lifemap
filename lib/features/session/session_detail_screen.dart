import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifemap/features/session/widgets/session_states_overview.dart';

import 'session_controller.dart';
import 'widgets/session_map_view.dart';
import 'widgets/session_timeline.dart';

class SessionDetailScreen extends StatefulWidget {
  final String sessionId;

  const SessionDetailScreen({super.key, required this.sessionId});

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  late final SessionController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SessionController());
    controller.loadSession(widget.sessionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journey Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            tooltip: 'Delete Session',
            onPressed: () => controller.deleteSession(context),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              const SessionMapView(),
              const SizedBox(height: 16),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SessionStatsOverview(),
              ),
              const SizedBox(height: 16),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SessionTimeline(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }
}

