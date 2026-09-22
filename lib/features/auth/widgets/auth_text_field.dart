import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final bool isPassword;
  final bool isObscure;
  final VoidCallback? onToggleVisibility;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.isPassword = false,
    this.isObscure = false,
    this.onToggleVisibility,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && isObscure,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isObscure
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
      ),
    );
  }
}