import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lifemap/features/ai_summary/ai_summary_screen.dart';
import 'package:lifemap/features/charts/charts_screen.dart';
import 'package:lifemap/features/session/session_detail_screen.dart';
import 'package:lifemap/features/session/session_history_screen.dart';
import 'package:lifemap/features/settings/settings_screen.dart';
import 'package:lifemap/features/tracking/active_tracking_screen.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/splash/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,

    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => SplashScreen(key: UniqueKey()),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.tracking,
        builder: (context, state) => const ActiveTrackingScreen(),
      ),
      GoRoute(
        path: AppRoutes.sessionDetail,
        builder: (context, state) {
          final id = state.pathParameters['sessionId'] ?? '';
          return SessionDetailScreen(sessionId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.charts,
        builder: (context, state) => const ChartsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(path: AppRoutes.history, builder: (context, state) => const SessionHistoryScreen(),),
      GoRoute(path: AppRoutes.aiSummary,builder:(context, state) => const AISummaryScreen(), )
    ],
  );
}

