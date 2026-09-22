import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/clippers/speech_bubble_clipper.dart';
import '../ai_controller.dart';
import 'typewriter_text.dart';

class SummaryBubble extends StatelessWidget {
  const SummaryBubble({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AIController>();
    final theme = Theme.of(context);

    return Obx(() {
      if (c.isGenerating.value) {
        return const Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final text = c.insight.value?.summaryText ?? '';

      return Column(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: theme.colorScheme.primary,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 4),
          ClipPath(
            clipper: const SpeechBubbleClipper(),
            child: Container(
              width: double.infinity,
              color: theme.colorScheme.surfaceContainerHighest,
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 18),
              child: TypewriterText(
                key: ValueKey(c.insight.value?.id ?? 'empty'),
                text: text,
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
              ),
            ),
          ),
        ],
      );
    });
  }
}

