import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/routes/app_pages.dart';
import '../../core/routes/app_routes.dart';
import '../../core/storage/storage_service.dart';

class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class OnboardingController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  late final PageController pageController;

  final RxInt currentPage = 0.obs;

  final List<OnboardingItem> items = const [
    OnboardingItem(
      title: 'Track Your Journey',
      description: 'LifeMap records your movement patterns seamlessly in the background with zero impact on battery life.',
      icon: Icons.navigation_rounded,
    ),
    OnboardingItem(
      title: 'See Your Patterns',
      description: 'Visualize daily paths on interactive maps, explore stop duration heatmaps, and analyze distance trends.',
      icon: Icons.map_rounded,
    ),
    OnboardingItem(
      title: 'AI-Powered Insights',
      description: 'Get intelligent, natural-language weekly summaries explaining your habits, routines, and milestones.',
      icon: Icons.auto_awesome_rounded,
    ),
    OnboardingItem(
      title: 'Location Access Needed',
      description: 'To map your routes and detect stop points automatically, LifeMap needs access to your location services.',
      icon: Icons.my_location_rounded,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < items.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  void skip() {
    pageController.animateToPage(
      items.length - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> completeOnboarding() async {
    await _storage.setOnboardingCompleted(true);

    final status = await Permission.location.request();

    if (status.isPermanentlyDenied) {
      Get.snackbar(
        'Permission Required',
        'Location permission is required for tracking. You can enable it anytime in Settings.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }

    AppPages.router.go(AppRoutes.login);
  }
}

