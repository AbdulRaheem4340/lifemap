import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dashboard_controller.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/recent_sessions_list.dart';
import 'widgets/sonar_start_button.dart';
import 'widgets/today_stats_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(DashboardController());
    controller.loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: const [
                DashboardHeader(),
                Positioned(bottom: -36, child: SonarStartButton()),
              ],
            ),
            const SizedBox(height: 52),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TodayStatsCard(),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: RecentSessionsList(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

