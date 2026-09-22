import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/painters/connection_painter.dart';
import '../ai_controller.dart';
import 'insight_card.dart';

class InsightHighlights extends StatelessWidget {
  const InsightHighlights({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AIController>();
    final theme = Theme.of(context);

    return Obx(() {
      final list = c.insight.value?.highlights ?? [];
      if (list.isEmpty) return const SizedBox.shrink();

      return Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: ConnectionPainter(
                lineColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                nodeCount: list.length,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Highlights',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...list.map(
                (h) => InsightCard(text: h),
              ),
            ],
          ),
        ],
      );
    });
  }
}