import 'dart:async';

import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:lifemap/services/foreground_service.dart';
import 'package:lifemap/services/notification_service.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/routes/app_pages.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/app_snackbar.dart';
import '../../models/location_point.dart';
import '../../models/session.dart';
import '../../repositories/session_repository.dart';
import '../../services/location_service.dart';
import '../dashboard/dashboard_controller.dart';

class TrackingController extends GetxController {
  final LocationService _locationService = LocationService();
  final SessionRepository _sessionRepository = SessionRepository();
  final Uuid _uuid = const Uuid();

  final MapController mapController = MapController();

  final RxBool isTracking = false.obs;
  final RxBool isAcquiringGps = false.obs;
  final RxBool followUser = true.obs;

  final RxInt elapsedSeconds = 0.obs;
  final RxDouble totalDistanceMeters = 0.0.obs;
  final RxDouble currentSpeedKmh = 0.0.obs;
  final RxDouble maxSpeedKmh = 0.0.obs;

  final RxList<LocationPoint> locationPoints = <LocationPoint>[].obs;
  final RxList<LocationPoint> stopPoints = <LocationPoint>[].obs;
  final Rxn<LatLng> currentLocation = Rxn<LatLng>();

  Timer? _timer;
  StreamSubscription<Position>? _positionSubscription;

  String? currentSessionId;
  DateTime? startTime;

  LocationPoint? _stopAnchorPoint;
  DateTime? _stopAnchorTime;

  @override
  void onClose() {
    _timer?.cancel();
    _positionSubscription?.cancel();
    super.onClose();
  }


  Future<void> startTracking() async {
    if (isTracking.value) return;

    if (await _locationService.isServiceDisabled()) {
      AppSnackbar.show(
        'Location Off',
        'Turn on Location, then return to LifeMap — we will resume automatically.',
        isError: true,
      );
      await _locationService.openLocationSettings();
      isTracking.value = false;
      isAcquiringGps.value = true;
      return;
    }

    final allowed = await _locationService.ensurePermission();
    if (!allowed) {
      final permanent = await _locationService.isPermanentlyDenied();
      AppSnackbar.show(
        'Permission Required',
        permanent
            ? 'Location is permanently denied. Open app settings and allow Location.'
            : 'Allow location access so LifeMap can track your path.',
        isError: true,
      );
      if (permanent) {
        await _locationService.openAppSettings();
      }
      return;
    }

    currentSessionId = _uuid.v4();
    startTime = DateTime.now();
    elapsedSeconds.value = 0;
    totalDistanceMeters.value = 0.0;
    currentSpeedKmh.value = 0.0;
    maxSpeedKmh.value = 0.0;
    locationPoints.clear();
    stopPoints.clear();
    _stopAnchorPoint = null;
    _stopAnchorTime = null;
    followUser.value = true;

    isTracking.value = true;
    isAcquiringGps.value = true;

    await ForegroundService.to.requestPermissions();
    await ForegroundService.to.startForegroundTask();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedSeconds.value++;

      final distanceKm = (totalDistanceMeters.value / 1000).toStringAsFixed(2);
      final durationStr = formatDuration(elapsedSeconds.value);

      ForegroundService.to.updateLiveStats(
        distanceText: '$distanceKm km',
        durationText: durationStr,
      );
    });

    await NotificationService.to.showTrackingNotification(
      title: 'LifeMap',
      body: 'Tracking active journey...',
    );

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedSeconds.value++;
    });

    final first = await _locationService.getCurrentPosition();
    if (first != null) {
      _onPositionUpdate(first);
      _moveCameraTo(LatLng(first.latitude, first.longitude), zoom: 17);
    }

    _positionSubscription?.cancel();
    _positionSubscription = _locationService.getPositionStream().listen(
      _onPositionUpdate,
      onError: (Object err) {
        AppSnackbar.show('GPS Error', err.toString(), isError: true);
      },
    );
  }


  Future<void> onAppResumed() async {
    if (!isTracking.value) {
      await startTracking();
      return;
    }

    final pos = await _locationService.getCurrentPosition();
    if (pos != null) {
      _onPositionUpdate(pos);
      _moveCameraTo(LatLng(pos.latitude, pos.longitude), zoom: 17);
      followUser.value = true;
      isAcquiringGps.value = false;
    }
  }


  void _onPositionUpdate(Position position) {
    final sessionId = currentSessionId;
    if (sessionId == null || !isTracking.value) return;

    if (position.accuracy > 40) {
      currentLocation.value = LatLng(position.latitude, position.longitude);
      isAcquiringGps.value = false;
      if (followUser.value) {
        _moveCameraTo(currentLocation.value!);
      }
      return;
    }

    final latLng = LatLng(position.latitude, position.longitude);
    currentLocation.value = latLng;
    isAcquiringGps.value = false;

    final speedKmh = position.speed < 0 ? 0.0 : position.speed * 3.6;
    final displaySpeed = (position.accuracy > 25 && speedKmh < 5)
        ? 0.0
        : speedKmh;
    currentSpeedKmh.value = displaySpeed;
    if (displaySpeed > maxSpeedKmh.value) {
      maxSpeedKmh.value = displaySpeed;
    }

    final point = LocationPoint(
      id: _uuid.v4(),
      latitude: position.latitude,
      longitude: position.longitude,
      altitude: position.altitude,
      speed: position.speed < 0 ? 0 : position.speed,
      accuracy: position.accuracy,
      timestamp: DateTime.now(),
      sessionId: sessionId,
    );

    if (locationPoints.isNotEmpty) {
      final last = locationPoints.last;
      final d = _locationService.calculateDistanceMeters(
        LatLng(last.latitude, last.longitude),
        latLng,
      );
      if (d >= 3.0 && displaySpeed >= 1.0) {
        totalDistanceMeters.value += d;
      }
    }

    locationPoints.add(point);
    _sessionRepository.saveLocationPoint(point);

    _detectStopPoint(point);

    if (followUser.value) {
      _moveCameraTo(latLng);
    }
  }

  void _moveCameraTo(LatLng target, {double? zoom}) {
    try {
      mapController.move(target, zoom ?? mapController.camera.zoom);
    } catch (_) {
    }
  }

  void recenterOnUser() {
    final loc = currentLocation.value;
    if (loc == null) return;
    followUser.value = true;
    _moveCameraTo(loc, zoom: 17);
  }

  void onUserInteractedWithMap() {
    followUser.value = false;
  }


  void _detectStopPoint(LocationPoint currentPoint) {
    final speed = currentPoint.speed;
    final isSlowEnough = speed <= AppConstants.stopMaxSpeedMps;

    final anchor = _stopAnchorPoint;
    final anchorTime = _stopAnchorTime;

    if (!isSlowEnough) {
      _stopAnchorPoint = currentPoint;
      _stopAnchorTime = currentPoint.timestamp;
      return;
    }

    if (anchor == null || anchorTime == null) {
      _stopAnchorPoint = currentPoint;
      _stopAnchorTime = currentPoint.timestamp;
      return;
    }

    final dist = _locationService.calculateDistanceMeters(
      LatLng(anchor.latitude, anchor.longitude),
      LatLng(currentPoint.latitude, currentPoint.longitude),
    );

    if (dist <= AppConstants.stopDetectionRadiusMeters) {
      final held = currentPoint.timestamp.difference(anchorTime).inSeconds;
      if (held >= AppConstants.stopDetectionDurationSeconds) {
        if (!stopPoints.any((sp) => sp.id == anchor.id)) {
          stopPoints.add(anchor.copyWith(isStopPoint: true));
        }
      }
      return;
    }

    _stopAnchorPoint = currentPoint;
    _stopAnchorTime = currentPoint.timestamp;
  }


  Future<void> stopTracking() async {
    _timer?.cancel();
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    isTracking.value = false;
    isAcquiringGps.value = false;

    await NotificationService.to.cancelTrackingNotification();
    await ForegroundService.to.stopForegroundTask();


    final sessId = currentSessionId;
    final startT = startTime;
    if (sessId == null || startT == null) {
      AppPages.router.go(AppRoutes.dashboard);
      return;
    }

    final endTime = DateTime.now();
    final avgSpeedKmh = elapsedSeconds.value > 0
        ? (totalDistanceMeters.value / 1000) / (elapsedSeconds.value / 3600.0)
        : 0.0;

    final session = Session(
      id: sessId,
      userId: 'local_user',
      startTime: startT,
      endTime: endTime,
      totalDistanceMeters: totalDistanceMeters.value,
      totalDurationSeconds: elapsedSeconds.value,
      locationPoints: List<LocationPoint>.from(locationPoints),
      stopPoints: List<LocationPoint>.from(stopPoints),
      averageSpeed: avgSpeedKmh,
      maxSpeed: maxSpeedKmh.value,
      syncStatus: SyncStatus.local,
    );

    await _sessionRepository.saveSession(session);

    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().loadDashboardData();
    }

    AppSnackbar.show(
      'Session Saved',
      '${(totalDistanceMeters.value / 1000).toStringAsFixed(2)} km · ${formatDuration(elapsedSeconds.value)}',
    );

    AppPages.router.go(AppRoutes.dashboard);
  }

  String formatDuration(int seconds) {
    final d = Duration(seconds: seconds);
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}

