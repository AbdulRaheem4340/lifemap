import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'tracking_controller.dart';
import 'widgets/live_stats_sheet.dart';
import 'widgets/tracking_map.dart';
import 'widgets/tracking_stop_button.dart';

class ActiveTrackingScreen extends StatefulWidget {
  const ActiveTrackingScreen({super.key});

  @override
  State<ActiveTrackingScreen> createState() => _ActiveTrackingScreenState();
}

class _ActiveTrackingScreenState extends State<ActiveTrackingScreen>
    with WidgetsBindingObserver {
  late final TrackingController controller;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    controller = Get.put(TrackingController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startTracking();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller.onAppResumed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: TrackingMap()),

          Positioned(
            top: top + 12,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Obx(() {
                  final acquiring = controller.isAcquiringGps.value;
                  final tracking = controller.isTracking.value;
                  final label = !tracking
                      ? 'Starting…'
                      : acquiring
                      ? 'Getting GPS…'
                      : 'Live Tracking';

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (acquiring)
                          SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.primary,
                            ),
                          )
                        else
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: tracking
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outline,
                            ),
                          ),
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const Spacer(),
                Obx(() {
                  if (controller.followUser.value) {
                    return const SizedBox.shrink();
                  }
                  return Material(
                    color: theme.colorScheme.surface,
                    shape: const CircleBorder(),
                    elevation: 2,
                    child: IconButton(
                      tooltip: 'Re-center',
                      onPressed: controller.recenterOnUser,
                      icon: Icon(
                        Icons.my_location_rounded,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TrackingStopButton(),
                SizedBox(height: 12),
                LiveStatsSheet(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

