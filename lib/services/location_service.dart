import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  Future<bool> ensurePermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return true;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<bool> isPermanentlyDenied() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.deniedForever;
  }

  Future<bool> isServiceDisabled() async {
    return !(await Geolocator.isLocationServiceEnabled());
  }

  Future<Position?> getCurrentPosition() async {
    final ok = await ensurePermission();
    if (!ok) return null;

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );
    } catch (_) {
      return Geolocator.getLastKnownPosition();
    }
  }

  Stream<Position> getPositionStream() {
    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );
    return Geolocator.getPositionStream(locationSettings: settings);
  }

  double calculateDistanceMeters(LatLng p1, LatLng p2) {
    return Geolocator.distanceBetween(
      p1.latitude,
      p1.longitude,
      p2.latitude,
      p2.longitude,
    );
  }

  Future<void> openLocationSettings() => Geolocator.openLocationSettings();

  Future<void> openAppSettings() => Geolocator.openAppSettings();
}

