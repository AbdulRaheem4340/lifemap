import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../charts_controller.dart';

class DistanceTrendChart extends StatelessWidget {
  const DistanceTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ChartsController>();
    final theme = Theme.of(context);

    return Obx(() {
      final values = c.dailyDistanceKm.toList();
      if (values.isEmpty) {
        return const SizedBox.shrink();
      }

      final maxY = values.fold<double>(0, (p, e) => e > p ? e : p);
      final chartMax = maxY <= 0 ? 1.0 : maxY * 1.25;

      final trend = <double>[];
      for (int i = 0; i < values.length; i++) {
        final a = values[i];
        final b = i > 0 ? values[i - 1] : a;
        final c3 = i > 1 ? values[i - 2] : b;
        trend.add((a + b + c3) / 3.0);
      }

      return Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Distance Trend',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Daily distance with smoothed average',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 180,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: chartMax,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (v) => FlLine(
                        color: theme.dividerColor.withValues(alpha: 0.5),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: const FlTitlesData(
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          for (int i = 0; i < values.length; i++)
                            FlSpot(i.toDouble(), values[i]),
                        ],
                        isCurved: true,
                        barWidth: 2,
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.35,
                        ),
                        dotData: const FlDotData(show: false),
                      ),
                      LineChartBarData(
                        spots: [
                          for (int i = 0; i < trend.length; i++)
                            FlSpot(i.toDouble(), trend[i]),
                        ],
                        isCurved: true,
                        barWidth: 3,
                        color: theme.colorScheme.secondary,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: theme.colorScheme.secondary.withValues(
                            alpha: 0.12,
                          ),
                        ),
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

