import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ai_controller.dart';
import 'widgets/data_transparency_card.dart';
import 'widgets/insight_highlights.dart';
import 'widgets/summary_bubble.dart';
import 'widgets/week_selector.dart';

class AISummaryScreen extends StatelessWidget {
  const AISummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AIController());
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LifeMap Insights'),
        actions: [
          IconButton(
            tooltip: 'Regenerate from latest sessions',
            onPressed: controller.regenerate,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const WeekSelector(),
            const SizedBox(height: 8),
            Text(
              'Summary is built from journeys saved on this device for the selected week. '
              'Tap refresh after new trips.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const SummaryBubble(),
            const SizedBox(height: 24),
            const InsightHighlights(),
            const SizedBox(height: 24),
            const DataTransparencyCard(),
            const SizedBox(height: 16),
            Obx(() {
              final i = controller.insight.value;
              if (i == null) {
                return Text(
                  'No insight yet — pull refresh or wait for generation.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall,
                );
              }
              return Column(
                children: [
                  Text(
                    'Based on ${i.sessionCount} session${i.sessionCount == 1 ? '' : 's'} · '
                    '${i.totalDistanceKm.toStringAsFixed(2)} km',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Generated ${_formatGenerated(i.generatedAt)} ',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  static String _formatGenerated(DateTime d) {
    final local = d.toLocal();
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    return '${local.day}/${local.month} '
        ' $hh:$mm';
  }
}

