import 'package:flutter/material.dart';

class DataTransparencyCard extends StatelessWidget {
  const DataTransparencyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      elevation: 0,
      child: ExpansionTile(
        leading: Icon(Icons.shield_rounded, color: theme.colorScheme.primary),
        title: Text(
          'Privacy & Data Transparency',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        iconColor: theme.colorScheme.primary,
        collapsedIconColor: theme.colorScheme.outline,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(
            'To generate insights, LifeMap only sends anonymous aggregate totals (total distance, time, and stop count) to the AI server. \n\nWe NEVER send your exact GPS coordinates, routes, or personal identity.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

