import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/painters/topo_background_painter.dart';
import 'auth_controller.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_mode_toggle.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/social_auth_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, this.initialIsLogin = true});

  final bool initialIsLogin;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController(initialIsLogin: initialIsLogin));
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: TopoBackgroundPainter(
                lineColor: theme.colorScheme.primary.withValues(alpha: 0.07),
              ),
            ),
          ),

          SingleChildScrollView(
            child: Column(
              children: [
                const AuthHeader(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      const AuthModeToggle(),
                      const SizedBox(height: 24),

                      Form(
                        key: controller.formKey,
                        child: Obx(() {
                          final isLogin = controller.isLogin.value;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: Column(
                              children: [
                                if (!isLogin) ...[
                                  AuthTextField(
                                    controller: controller.nameController,
                                    label: 'Full Name',
                                    prefixIcon: Icons.person_rounded,
                                    validator: controller.validateName,
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                AuthTextField(
                                  controller: controller.emailController,
                                  label: 'Email Address',
                                  prefixIcon: Icons.email_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: controller.validateEmail,
                                ),
                                const SizedBox(height: 16),

                                AuthTextField(
                                  controller: controller.passwordController,
                                  label: 'Password',
                                  prefixIcon: Icons.lock_rounded,
                                  isPassword: true,
                                  isObscure:
                                      !controller.isPasswordVisible.value,
                                  onToggleVisibility:
                                      controller.togglePasswordVisibility,
                                  validator: controller.validatePassword,
                                ),
                                const SizedBox(height: 24),

                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : controller.submitAuth,
                                    child: controller.isLoading.value
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                            ),
                                          )
                                        : Text(isLogin ? 'Login' : 'Sign Up'),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: Divider(color: theme.dividerColor)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('OR', style: theme.textTheme.bodySmall),
                          ),
                          Expanded(child: Divider(color: theme.dividerColor)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      SocialAuthButton(onPressed: controller.signInWithGoogle),
                      const SizedBox(height: 32),
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

