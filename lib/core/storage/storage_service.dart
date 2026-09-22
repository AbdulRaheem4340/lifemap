import 'package:get_storage/get_storage.dart';

class StorageService {
  static const String _boxName = 'lifemap_preferences';

  static const String _keyDarkMode = 'is_dark_mode';
  static const String _keyOnboardingDone = 'has_completed_onboarding';
  static const String _keyPreferredUnits = 'preferred_units';

  late final GetStorage _box;

  Future<void> init() async {
    await GetStorage.init(_boxName);
    _box = GetStorage(_boxName);
  }


  bool get isDarkMode => _box.read(_keyDarkMode) ?? false;

  Future<void> setDarkMode(bool value) async {
    await _box.write(_keyDarkMode, value);
  }


  bool get hasCompletedOnboarding =>
      _box.read(_keyOnboardingDone) ?? false;

  Future<void> setOnboardingCompleted(bool value) async {
    await _box.write(_keyOnboardingDone, value);
  }


  String get preferredUnits => _box.read(_keyPreferredUnits) ?? 'km';

  Future<void> setPreferredUnits(String value) async {
    await _box.write(_keyPreferredUnits, value);
  }

  Future<void> clearAll() async {
    await _box.erase();
  }
}