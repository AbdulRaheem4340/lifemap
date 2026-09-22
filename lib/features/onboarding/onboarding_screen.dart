import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifemap/features/onboarding/widget/onboarding_card_content.dart';
import 'package:lifemap/features/onboarding/widget/onboarding_navigation_bar.dart';
import 'package:lifemap/features/onboarding/widget/onboarding_top_illustration.dart';

import 'onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      body: Column(
        children: [
          Obx(
            () => OnboardingTopIllustration(
              icon: controller.items[controller.currentPage.value].icon,
            ),
          ),

          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              itemCount: controller.items.length,
              itemBuilder: (context, index) {
                final item = controller.items[index];
                return OnboardingCardContent(
                  title: item.title,
                  description: item.description,
                );
              },
            ),
          ),

          const OnboardingNavigationBar(),
        ],
      ),
    );
  }
}

