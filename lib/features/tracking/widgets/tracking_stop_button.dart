import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../tracking_controller.dart';

class TrackingStopButton extends StatelessWidget {
  const TrackingStopButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton.extended(
      heroTag: 'stop_tracking_fab',
      backgroundColor: theme.colorScheme.error,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.stop_circle_rounded),
      label: const Text('End Session'),
      onPressed: () async {
        if (!Get.isRegistered<TrackingController>()) return;

        final controller = Get.find<TrackingController>();

        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('End Tracking Session?'),
            content: const Text(
              'Save this route, stops, and stats to LifeMap?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Resume'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: Colors.white,
                ),
                child: const Text('End & Save'),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          await controller.stopTracking();
        }
      },
    );
  }
}

