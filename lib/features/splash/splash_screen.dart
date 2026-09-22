import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/app_routes.dart';
import '../../core/storage/storage_service.dart';
import '../../widgets/painters/route_line_painter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _progressAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startVisualJourney();
    });
  }

  Future<void> _startVisualJourney() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    _animationController.reset();
    await _animationController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    final storage = Get.find<StorageService>();
    if (!storage.hasCompletedOnboarding) {
      context.go(AppRoutes.onboarding);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildAnimatedPathOverlay(context),

          Center(child: _buildBrandingSection(context)),
        ],
      ),
    );
  }


  Widget _buildAnimatedPathOverlay(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: RouteLinePainter(
            progress: _progressAnimation.value,
            pathColor: theme.colorScheme.primary,
            dotColor: theme.colorScheme.secondary,
          ),
        );
      },
    );
  }

  Widget _buildBrandingSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Icon(
            Icons.map_rounded,
            size: 40,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'LifeMap',
          style: theme.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your life, mapped and understood.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}