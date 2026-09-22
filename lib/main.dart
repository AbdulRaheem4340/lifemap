import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lifemap/models/ai_insight.dart';
import 'package:lifemap/services/foreground_service.dart';
import 'package:lifemap/services/notification_service.dart';
import 'core/constants/app_constants.dart';
import 'core/routes/app_pages.dart';
import 'core/storage/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'models/location_point.dart';
import 'models/session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(LocationPointAdapter());
  Hive.registerAdapter(SyncStatusAdapter());
  Hive.registerAdapter(SessionAdapter());
  Hive.registerAdapter(AIInsightAdapter());

  await Hive.openBox<Session>(AppConstants.boxSessions);
  await Hive.openBox<LocationPoint>(AppConstants.boxLocationPoints);
  await Hive.openBox<AIInsight>(AppConstants.boxAiInsights);

  final storageService = StorageService();
  await storageService.init();
  Get.put<StorageService>(storageService, permanent: true);
  Get.put<ThemeController>(ThemeController(storageService), permanent: true);
  await Get.putAsync(() => NotificationService().init(), permanent: true);
  await Get.putAsync(() => ForegroundService().init(), permanent: true);


  runApp(const LifeMapApp());
}

class LifeMapApp extends StatelessWidget {
  const LifeMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp.router(
        title: 'LifeMap',
        debugShowCheckedModeBanner: false,

        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeController.themeMode,

        routeInformationProvider: AppPages.router.routeInformationProvider,
        routeInformationParser: AppPages.router.routeInformationParser,
        routerDelegate: AppPages.router.routerDelegate,
        backButtonDispatcher: AppPages.router.backButtonDispatcher,
      ),
    );
  }
}

