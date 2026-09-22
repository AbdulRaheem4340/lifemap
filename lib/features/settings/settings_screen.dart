import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifemap/features/settings/widgets/appearence_settings_group.dart';
import 'package:lifemap/features/settings/widgets/data_mangement_group.dart';
import '../../widgets/painters/topo_divider_painter.dart';
import 'settings_controller.dart';
import 'widgets/account_settings_group.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/tracking_settings_group.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsController());
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ProfileHeaderCard(),
            const SizedBox(height: 48),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(title: 'Appearance & Units'),
                  const SizedBox(height: 8),
                  const AppearanceSettingsGroup(),
                  _CustomTopoDivider(color: theme.colorScheme.outlineVariant),

                  _SectionTitle(title: 'Tracking & Permissions'),
                  const SizedBox(height: 8),
                  const TrackingSettingsGroup(),
                  _CustomTopoDivider(color: theme.colorScheme.outlineVariant),

                  _SectionTitle(title: 'Data & Storage'),
                  const SizedBox(height: 8),
                  const DataManagementGroup(),
                  _CustomTopoDivider(color: theme.colorScheme.outlineVariant),

                  const SizedBox(height: 8),
                  const AccountSettingsGroup(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _CustomTopoDivider extends StatelessWidget {
  final Color color;

  const _CustomTopoDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: 12,
        width: double.infinity,
        child: CustomPaint(
          painter: TopoDividerPainter(lineColor: color.withValues(alpha: 0.4)),
        ),
      ),
    );
  }
}

