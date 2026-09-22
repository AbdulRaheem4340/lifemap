import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/routes/app_pages.dart';
import '../../core/routes/app_routes.dart';
import '../../core/storage/storage_service.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/utils/app_snackbar.dart';
import '../../repositories/session_repository.dart';
import '../dashboard/dashboard_controller.dart';

class SettingsController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final ThemeController _themeController = Get.find<ThemeController>();
  final SessionRepository _sessionRepository = SessionRepository();

  final RxString selectedUnits = 'km'.obs;

  @override
  void onInit() {
    super.onInit();
    selectedUnits.value = _storage.preferredUnits;
  }

  bool get isDarkMode => _themeController.isDarkMode;

  void toggleTheme() {
    _themeController.toggleTheme();
  }

  Future<void> setUnits(String units) async {
    selectedUnits.value = units;
    await _storage.setPreferredUnits(units);

    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().loadDashboardData();
    }
  }

  Future<void> exportData() async {
    final sessions = _sessionRepository.getAllSessions();
    if (sessions.isEmpty) {
      AppSnackbar.show('No Data', 'There are no sessions recorded to export.');
      return;
    }

    final jsonList = sessions.map((s) => s.toMap()).toList();
    final jsonString = const JsonEncoder.withIndent('  ').convert(jsonList);

    await Clipboard.setData(ClipboardData(text: jsonString));

    AppSnackbar.show(
      'Export Successful',
      'Exported ${sessions.length} sessions as JSON. Data copied to clipboard!',
    );
  }

  Future<void> clearLocalData(BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Local Data?'),
        content: const Text(
          'This will permanently delete all saved journeys and points from local memory. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();

              final sessions = _sessionRepository.getAllSessions();
              for (final s in sessions) {
                await _sessionRepository.deleteSession(s.id);
              }

              if (Get.isRegistered<DashboardController>()) {
                Get.find<DashboardController>().loadDashboardData();
              }

              AppSnackbar.show(
                'Storage Cleared',
                'All local sessions have been deleted.',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out?'),
        content: const Text('Are you sure you want to log out of LifeMap?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              AppPages.router.go(AppRoutes.login);
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

