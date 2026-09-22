import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../widgets/clippers/map_viewport_clipper.dart';
import '../session_controller.dart';

const ColorFilter _darkMapFilter = ColorFilter.matrix(<double>[
  -0.2126,
  -0.7152,
  -0.0722,
  0,
  255,
  -0.2126,
  -0.7152,
  -0.0722,
  0,
  255,
  -0.2126,
  -0.7152,
  -0.0722,
  0,
  255,
  0,
  0,
  0,
  1,
  0,
]);

class SessionMapView extends StatelessWidget {
  const SessionMapView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SessionController>();
    final themeController = Get.find<ThemeController>();
    final theme = Theme.of(context);

    return Obx(() {
      final s = controller.session.value;
      if (s == null || s.locationPoints.isEmpty) {
        return const SizedBox(height: 280);
      }

      final isDark = themeController.isDarkMode;
      final allLatLngs = s.locationPoints
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();
      final LatLng initialCenter = allLatLngs.first;

      return ClipPath(
        clipper: const MapViewportClipper(bottomRadius: 28),
        child: SizedBox(
          height: 320,
          width: double.infinity,
          child: AnimatedBuilder(
            animation: controller.replayProgressAnimation,
            builder: (context, child) {
              final double progress = controller.replayProgressAnimation.value;
              final int visibleCount = (allLatLngs.length * progress)
                  .round()
                  .clamp(0, allLatLngs.length);
              final visiblePoints = allLatLngs.take(visibleCount).toList();

              return Stack(
                children: [
                  FlutterMap(
                    mapController: controller.mapController,
                    options: MapOptions(
                      initialCenter: initialCenter,
                      initialZoom: 15.0,
                      onMapReady: () {
                        final bounds = controller.getSessionBounds();
                        if (bounds != null) {
                          controller.mapController.fitCamera(
                            CameraFit.bounds(
                              bounds: bounds,
                              padding: const EdgeInsets.all(40),
                            ),
                          );
                        }
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: AppConstants.lightTileUrl,
                        userAgentPackageName: 'com.lifemap.lifemap',
                        tileBuilder: isDark
                            ? (context, tileWidget, tile) => ColorFiltered(
                                colorFilter: _darkMapFilter,
                                child: tileWidget,
                              )
                            : null,
                      ),

                      PolylineLayer(
                        polylines: [
                          if (visiblePoints.length >= 2)
                            Polyline(
                              points: visiblePoints,
                              strokeWidth: 5.0,
                              color: theme.colorScheme.primary,
                            ),
                        ],
                      ),

                      MarkerLayer(
                        markers: [
                          Marker(
                            point: allLatLngs.first,
                            width: 28,
                            height: 28,
                            child: const CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),

                          ...s.stopPoints
                              .where((sp) {
                                final idx = s.locationPoints.indexWhere(
                                  (p) => p.id == sp.id,
                                );
                                return idx != -1 && idx <= visibleCount;
                              })
                              .map(
                                (sp) => Marker(
                                  point: LatLng(sp.latitude, sp.longitude),
                                  width: 24,
                                  height: 24,
                                  child: Icon(
                                    Icons.location_on_rounded,
                                    color: theme.colorScheme.secondary,
                                    size: 24,
                                  ),
                                ),
                              ),

                          if (progress >= 0.98 && allLatLngs.isNotEmpty)
                            Marker(
                              point: allLatLngs.last,
                              width: 28,
                              height: 28,
                              child: const CircleAvatar(
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.flag_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),

                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton.small(
                      heroTag: 'replay_btn',
                      onPressed: controller.restartReplayAnimation,
                      backgroundColor: theme.colorScheme.surface,
                      foregroundColor: theme.colorScheme.primary,
                      tooltip: 'Replay Path',
                      child: const Icon(Icons.replay_rounded),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    });
  }
}

