import 'dart:io';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';

class ForegroundService extends GetxService {
  static ForegroundService get to => Get.find<ForegroundService>();

  static const int serviceId = 888;

  Future<ForegroundService> init() async {
    FlutterForegroundTask.initCommunicationPort();

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'lifemap_foreground_channel',
        channelName: 'LifeMap Background Tracking',
        channelDescription:
            'Keeps GPS tracking active while the app is in background or screen is locked.',
            enableVibration: true,
            playSound: true,
        channelImportance: NotificationChannelImportance.HIGH,
        priority: NotificationPriority.LOW,
        showBadge: true

      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: false,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );

    return this;
  }

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }

      final NotificationPermission notificationPermission =
          await FlutterForegroundTask.checkNotificationPermission();
      if (notificationPermission != NotificationPermission.granted) {
        await FlutterForegroundTask.requestNotificationPermission();
      }
    }
    return true;
  }

  Future<bool> startForegroundTask() async {
    if (await FlutterForegroundTask.isRunningService) {
      return true;
    }

    await FlutterForegroundTask.startService(
      serviceId: serviceId,
      notificationTitle: 'LifeMap',
      notificationText: 'Tracking your journey in real-time...',
      notificationIcon: NotificationIcon(

         metaDataName: 'ic_notification',
      ),
    );

    return await FlutterForegroundTask.isRunningService;
  }

  Future<void> updateLiveStats({
    required String distanceText,
    required String durationText,
  }) async {
    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.updateService(
        notificationTitle: 'LifeMap · $distanceText',
        notificationText: 'Active Duration: $durationText',
      );
    }
  }

  Future<bool> stopForegroundTask() async {
    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.stopService();
    }
    return true;
  }
}