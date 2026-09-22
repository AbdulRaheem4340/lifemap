import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../storage/storage_service.dart';

class ThemeController extends GetxController {
  final StorageService _storage;

  ThemeController(this._storage);


  final Rx<ThemeMode> _themeMode = ThemeMode.light.obs;

  ThemeMode get themeMode => _themeMode.value;

  bool get isDarkMode => _themeMode.value == ThemeMode.dark;


  @override
  void onInit() {
    super.onInit();
    _loadSavedTheme();
  }

  void _loadSavedTheme() {
    final bool savedDarkMode = _storage.isDarkMode;
    _themeMode.value = savedDarkMode ? ThemeMode.dark : ThemeMode.light;

    Get.changeThemeMode(_themeMode.value);
  }


  void toggleTheme() {
    final ThemeMode newMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;

    _themeMode.value = newMode;

    Get.changeThemeMode(newMode);

    _storage.setDarkMode(isDarkMode);
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    Get.changeThemeMode(mode);
    _storage.setDarkMode(mode == ThemeMode.dark);
  }
}

