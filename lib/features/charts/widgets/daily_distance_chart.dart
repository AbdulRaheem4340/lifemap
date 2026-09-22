import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../charts_controller.dart';

class DailyDistanceChart extends StatelessWidget {
  const DailyDistanceChart({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ChartsController>();
    final theme = Theme.of(context);

    return Obx(() {
      final values = c.dailyDistanceKm.toList();
      final labels = c.dailyLabels.toList();
      if (values.isEmpty) {
        return const _EmptyChart(label: 'No distance data yet');
      }

      final maxY = values.fold<double>(0, (p, e) => e > p ? e : p);
      final chartMax = maxY <= 0 ? 1.0 : maxY * 1.25;

      return Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daily Distance',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text('Kilometers per day', style: theme.textTheme.bodySmall),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
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
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          interval: chartMax <= 0.5
                              ? 0.1
                              : chartMax <= 2
                              ? 0.5
                              : chartMax <= 10
                              ? 2
                              : 5,
                          getTitlesWidget: (v, m) {
                            if (v < 0) return const SizedBox.shrink();
                            if (v == 0) {
                              return Text(
                                '0',
                                style: theme.textTheme.labelSmall,
                              );
                            }
                            final text = v >= 10
                                ? v.toStringAsFixed(0)
                                : v.toStringAsFixed(1);
                            return Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Text(
                                text,
                                style: theme.textTheme.labelSmall,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, m) {
                            final i = v.toInt();
                            if (i < 0 || i >= labels.length) {
                              return const SizedBox.shrink();
                            }
                            if (labels.length > 10 && i % 3 != 0) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                labels[i],
                                style: theme.textTheme.labelSmall,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: [
                      for (int i = 0; i < values.length; i++)
                        BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: values[i],
                              width: labels.length > 10 ? 6 : 12,
                              borderRadius: BorderRadius.circular(4),
                              color: theme.colorScheme.primary,
                            ),
                          ],
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

class _EmptyChart extends StatelessWidget {
  final String label;
  const _EmptyChart({required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(height: 160, child: Center(child: Text(label))),
    );
  }
}

