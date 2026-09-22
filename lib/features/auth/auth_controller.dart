import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_pages.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/app_snackbar.dart';

class AuthController extends GetxController {
  AuthController({this.initialIsLogin = true});

  final bool initialIsLogin;

  final RxBool isLogin = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    isLogin.value = initialIsLogin;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void toggleAuthMode() {
    isLogin.value = !isLogin.value;
    formKey.currentState?.reset();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String? validateName(String? value) {
    if (!isLogin.value && (value == null || value.trim().isEmpty)) {
      return 'Please enter your full name';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> submitAuth() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1200));
    isLoading.value = false;

    AppSnackbar.show(
      isLogin.value ? 'Welcome Back!' : 'Account Created!',
      isLogin.value
          ? 'Logged in successfully.'
          : 'Your LifeMap account is ready.',
    );

    AppPages.router.go(AppRoutes.dashboard);
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1000));
    isLoading.value = false;

    AppSnackbar.show('Google Sign In', 'Signed in with Google successfully.');

    AppPages.router.go(AppRoutes.dashboard);
  }
}

