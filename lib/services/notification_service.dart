import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../core/utils/app_snackbar.dart';

class NotificationService extends GetxService {
  static NotificationService get to => Get.find<NotificationService>();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const int trackingNotificationId = 888;
  static const String channelId = 'lifemap_tracking_channel';
  static const String channelName = 'Journey Tracking';
  static const String channelDescription =
      'Shows ongoing tracking status while a journey is active.';

  Future<NotificationService> init() async {
    const androidInitSettings = AndroidInitializationSettings(
      'ic_notification',
    );

    const darwinInitSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: darwinInitSettings,
    );

    await _notificationsPlugin.initialize(settings: initSettings);
    return this;
  }

  Future<bool> requestPermission() async {
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      final granted = await androidImplementation
          .requestNotificationsPermission();
      if (granted == false) {
        AppSnackbar.show(
          'Notifications Disabled',
          'Tracking will work, but status will not appear in the system tray.',
          isError: true,
        );
        return false;
      }
      return true;
    }

    final iosImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    if (iosImplementation != null) {
      final granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  Future<void> showTrackingNotification({
    String title = 'LifeMap',
    String body = 'Tracking your journey in real-time...',
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      icon: 'ic_notification',
      largeIcon: const DrawableResourceAndroidBitmap(
        '@mipmap/ic_launcher',
      ),
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      showWhen: true,
      color: const Color(0xFF0D7377),
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: false,
      interruptionLevel: InterruptionLevel.passive,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _notificationsPlugin.show(
      id: trackingNotificationId,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }

  Future<void> cancelTrackingNotification() async {
    await _notificationsPlugin.cancel(id: trackingNotificationId);
  }
}

