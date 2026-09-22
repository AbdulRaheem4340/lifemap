import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth_controller.dart';

class AuthModeToggle extends StatelessWidget {
  const AuthModeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final theme = Theme.of(context);

    return Obx(() {
      final isLogin = controller.isLogin.value;

      return Container(
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: isLogin ? null : controller.toggleAuthMode,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    color: isLogin
                        ? theme.colorScheme.surface
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isLogin
                        ? [
                            BoxShadow(
                              color: theme.shadowColor.withValues(alpha: 0.1),
                              blurRadius: 4,
                            ),
                          ]
                        : [],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Login',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: isLogin ? FontWeight.bold : FontWeight.normal,
                      color: isLogin
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: !isLogin ? null : controller.toggleAuthMode,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    color: !isLogin
                        ? theme.colorScheme.surface
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: !isLogin
                        ? [
                            BoxShadow(
                              color: theme.shadowColor.withValues(alpha: 0.1),
                              blurRadius: 4,
                            ),
                          ]
                        : [],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Sign Up',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: !isLogin
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: !isLogin
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

