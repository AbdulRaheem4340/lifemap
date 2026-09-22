import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/painters/dotted_path_painter.dart';
import '../onboarding_controller.dart';

class OnboardingNavigationBar extends StatelessWidget {
  const OnboardingNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Obx(() {
        final isLastPage =
            controller.currentPage.value == controller.items.length - 1;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isLastPage
                ? const SizedBox(width: 60)
                : TextButton(
                    onPressed: controller.skip,
                    child: const Text('Skip'),
                  ),

            CustomPaint(
              size: const Size(80, 20),
              painter: DottedPathPainter(
                totalSteps: controller.items.length,
                currentStep: controller.currentPage.value.toDouble(),
                activeColor: theme.colorScheme.primary,
                inactiveColor: theme.colorScheme.outlineVariant,
              ),
            ),

            ElevatedButton(
              onPressed: controller.nextPage,
              style: ElevatedButton.styleFrom(
                shape: isLastPage
                    ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      )
                    : const CircleBorder(),
                padding: isLastPage
                    ? const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
                    : const EdgeInsets.all(16),
              ),
              child: isLastPage
                  ? const Text('Enable Location')
                  : const Icon(Icons.arrow_forward_rounded),
            ),
          ],
        );
      }),
    );
  }
}

