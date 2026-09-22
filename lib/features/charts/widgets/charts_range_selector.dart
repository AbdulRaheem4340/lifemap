import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../charts_controller.dart';

class ChartsRangeSelector extends StatelessWidget {
  const ChartsRangeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ChartsController>();
    final theme = Theme.of(context);

    return Obx(() {
      return Row(
        children: [
          Expanded(
            child: CupertinoSlidingSegmentedControl<ChartsRange>(
              groupValue: c.range.value,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              thumbColor: theme.colorScheme.primary,
              children: {
                ChartsRange.week: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'This Week',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: c.range.value == ChartsRange.week
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ChartsRange.month: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'This Month',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: c.range.value == ChartsRange.month
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              },
              onValueChanged: (value) {
                if (value != null) c.setRange(value);
              },
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${c.sessionCount.value} sessions',
            style: theme.textTheme.bodySmall,
          ),
        ],
      );
    });
  }
}

