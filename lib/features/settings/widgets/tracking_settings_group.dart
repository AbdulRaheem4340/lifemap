import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class TrackingSettingsGroup extends StatelessWidget {
  const TrackingSettingsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.my_location_rounded,
              color: theme.colorScheme.primary,
            ),
            title: const Text('Location Permissions'),
            subtitle: const Text('Open system location permission settings'),
            trailing: const Icon(Icons.open_in_new_rounded, size: 18),
            onTap: () => Geolocator.openAppSettings(),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Background Tracking Note',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'LifeMap currently operates in foreground active mode. Keep the app open or phone unlocked while recording journeys.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}