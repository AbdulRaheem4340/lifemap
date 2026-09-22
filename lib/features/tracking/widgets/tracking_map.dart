import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/theme_controller.dart';
import '../tracking_controller.dart';
import 'pulsing_location_marker.dart';

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

class TrackingMap extends StatelessWidget {
  const TrackingMap({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TrackingController>();
    final themeController = Get.find<ThemeController>();
    final theme = Theme.of(context);

    return Obx(() {
      final isDark = themeController.isDarkMode;
      final currentLoc = controller.currentLocation.value;
      final center = currentLoc ?? const LatLng(33.6844, 73.0479);

      final polylinePoints = controller.locationPoints
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();

      return FlutterMap(
        mapController: controller.mapController,
        options: MapOptions(
          initialCenter: center,
          initialZoom: 16,
          onPositionChanged: (position, hasGesture) {
            if (hasGesture) {
              controller.onUserInteractedWithMap();
            }
          },
        ),
        children: [
          TileLayer(
            urlTemplate: AppConstants.lightTileUrl,
            userAgentPackageName: 'com.example.lifemap',
            maxZoom: 19,
            tileBuilder: isDark
                ? (context, tileWidget, tile) {
                    return ColorFiltered(
                      colorFilter: _darkMapFilter,
                      child: tileWidget,
                    );
                  }
                : null,
          ),
          PolylineLayer(
            polylines: [
              if (polylinePoints.length >= 2)
                Polyline(
                  points: polylinePoints,
                  strokeWidth: 5,
                  color: theme.colorScheme.primary,
                ),
            ],
          ),
          MarkerLayer(
            markers: [
              ...controller.stopPoints.map(
                (sp) => Marker(
                  point: LatLng(sp.latitude, sp.longitude),
                  width: 28,
                  height: 28,
                  child: Icon(
                    Icons.location_on_rounded,
                    color: theme.colorScheme.secondary,
                    size: 28,
                  ),
                ),
              ),
              if (currentLoc != null)
                Marker(
                  point: currentLoc,
                  width: 52,
                  height: 52,
                  child: const PulsingLocationMarker(),
                ),
            ],
          ),
          SimpleAttributionWidget(
            source: Text(
              AppConstants.tileAttribution,
              style: theme.textTheme.labelSmall,
            ),
          ),
        ],
      );
    });
  }
}

