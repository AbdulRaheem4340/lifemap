import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'charts_controller.dart';
import 'widgets/activity_heatmap.dart';
import 'widgets/charts_range_selector.dart';
import 'widgets/charts_summary_strip.dart';
import 'widgets/daily_distance_chart.dart';
import 'widgets/distance_trend_chart.dart';
import 'widgets/moving_stopped_chart.dart';

class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ChartsController());

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ChartsRangeSelector(),
            SizedBox(height: 16),
            ChartsSummaryStrip(),
            SizedBox(height: 16),
            DailyDistanceChart(),
            SizedBox(height: 16),
            DistanceTrendChart(),
            SizedBox(height: 16),
            ActivityHeatmap(),
            SizedBox(height: 16),
            MovingStoppedChart(),
          ],
        ),
      ),
    );
  }
}

