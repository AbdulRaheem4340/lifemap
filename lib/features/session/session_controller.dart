import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../core/routes/app_pages.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/app_snackbar.dart';
import '../../models/session.dart';
import '../../repositories/session_repository.dart';
import '../../services/geocoding_service.dart';

class SessionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final SessionRepository _repository = SessionRepository();
  final GeocodingService _geocodingService = GeocodingService();

  final MapController mapController = MapController();

  late AnimationController replayAnimationController;
  late Animation<double> replayProgressAnimation;

  final Rxn<Session> session = Rxn<Session>();
  final RxBool isLoading = true.obs;

  final RxString startAddress = 'Loading address...'.obs;
  final RxString endAddress = 'Loading address...'.obs;
  final RxMap<String, String> stopAddresses = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    replayAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    replayProgressAnimation = CurvedAnimation(
      parent: replayAnimationController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void onClose() {
    replayAnimationController.dispose();
    super.onClose();
  }

  void loadSession(String sessionId) async {
    isLoading.value = true;

    final loadedSession = _repository.getSession(sessionId);
    if (loadedSession == null) {
      AppSnackbar.show('Error', 'Session not found', isError: true);
      AppPages.router.go(AppRoutes.dashboard);
      return;
    }

    session.value = loadedSession;
    isLoading.value = false;

    replayAnimationController.reset();
    replayAnimationController.forward();

    _fetchAddresses(loadedSession);
  }

  void restartReplayAnimation() {
    replayAnimationController.reset();
    replayAnimationController.forward();
  }

  void _fetchAddresses(Session s) async {
    if (s.locationPoints.isNotEmpty) {
      final firstPoint = s.locationPoints.first;
      final lastPoint = s.locationPoints.last;

      startAddress.value = await _geocodingService.getPlaceName(
        LatLng(firstPoint.latitude, firstPoint.longitude),
      );

      endAddress.value = await _geocodingService.getPlaceName(
        LatLng(lastPoint.latitude, lastPoint.longitude),
      );
    }

    for (final stop in s.stopPoints) {
      final name = await _geocodingService.getPlaceName(
        LatLng(stop.latitude, stop.longitude),
      );
      stopAddresses[stop.id] = name;
    }
  }

  LatLngBounds? getSessionBounds() {
    final s = session.value;
    if (s == null || s.locationPoints.isEmpty) return null;

    final points = s.locationPoints
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();
    if (points.isEmpty) return null;

    return LatLngBounds.fromPoints(points);
  }

  Future<void> deleteSession(BuildContext context) async {
    final s = session.value;
    if (s == null) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Journey?'),
        content: const Text(
          'This session and its location points will be permanently deleted from LifeMap.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _repository.deleteSession(s.id);
              AppSnackbar.show('Deleted', 'Journey has been removed.');
              AppPages.router.go(AppRoutes.dashboard);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String formatDuration(int seconds) {
    final d = Duration(seconds: seconds);
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;

    if (h > 0) return '${h}h ${m}m ${s}s';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }
}

