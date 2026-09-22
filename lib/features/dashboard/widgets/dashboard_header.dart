import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../core/routes/app_pages.dart';
import '../../../core/routes/app_routes.dart';
import '../../../widgets/clippers/notch_clipper.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todayDate = DateFormat('EEEE, MMM d').format(DateTime.now());

    final double topInset = MediaQuery.viewPaddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: ClipPath(
        clipper: const NotchClipper(notchRadius: 44),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                Color.lerp(
                  theme.colorScheme.primary,
                  theme.colorScheme.primaryContainer,
                  0.35,
                )!,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, topInset + 16, 12, 56),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Good Day, Explorer',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        todayDate,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimary.withValues(
                            alpha: 0.85,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Analytics',
                  onPressed: () => AppPages.router.push(AppRoutes.charts),
                  icon: Icon(
                    Icons.insights_rounded,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                IconButton(
                  tooltip: 'Insights',
                  onPressed: () => AppPages.router.push(AppRoutes.aiSummary),
                  icon: Icon(
                    Icons.auto_awesome,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => AppPages.router.push(AppRoutes.settings),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: theme.colorScheme.onPrimary.withValues(
                      alpha: 0.2,
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

