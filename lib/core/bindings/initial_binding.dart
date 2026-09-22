import 'package:get/get.dart';
import '../storage/storage_service.dart';
import '../theme/theme_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StorageService(), permanent: true);

    Get.put(
      ThemeController(Get.find<StorageService>()),
      permanent: true,
    );
  }
}