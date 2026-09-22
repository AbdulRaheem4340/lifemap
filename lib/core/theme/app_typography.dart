import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  static const String _heading = 'Roboto';
  static const String _body = 'Roboto';

  static const double _headingSpacing = 0.5;
  static const double _bodySpacing = 0.15;
  static const double _labelSpacing = 0.4;

  static TextTheme buildTextTheme(Color textColor) {
    final Color secondaryColor = textColor.withValues(alpha:  0.7);
    final Color tertiaryColor = textColor.withValues(alpha:  0.45);

    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: _heading,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: _headingSpacing,
        height: 1.2,
        color: textColor,
      ),
      displayMedium: TextStyle(
        fontFamily: _heading,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: _headingSpacing,
        height: 1.2,
        color: textColor,
      ),
      displaySmall: TextStyle(
        fontFamily: _heading,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: _headingSpacing,
        height: 1.3,
        color: textColor,
      ),

      headlineLarge: TextStyle(
        fontFamily: _heading,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: _headingSpacing,
        height: 1.3,
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: _heading,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: _headingSpacing,
        height: 1.3,
        color: textColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: _heading,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: _headingSpacing,
        height: 1.4,
        color: textColor,
      ),

      titleLarge: TextStyle(
        fontFamily: _heading,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: _bodySpacing,
        height: 1.4,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontFamily: _heading,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: _bodySpacing,
        height: 1.4,
        color: textColor,
      ),
      titleSmall: TextStyle(
        fontFamily: _heading,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: _bodySpacing,
        height: 1.4,
        color: secondaryColor,
      ),

      bodyLarge: TextStyle(
        fontFamily: _body,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: _bodySpacing,
        height: 1.5,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: _body,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: _bodySpacing,
        height: 1.5,
        color: secondaryColor,
      ),
      bodySmall: TextStyle(
        fontFamily: _body,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: _bodySpacing,
        height: 1.5,
        color: tertiaryColor,
      ),

      labelLarge: TextStyle(
        fontFamily: _body,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: _labelSpacing,
        height: 1.2,
        color: textColor,
      ),
      labelMedium: TextStyle(
        fontFamily: _body,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: _labelSpacing,
        height: 1.2,
        color: secondaryColor,
      ),
      labelSmall: TextStyle(
        fontFamily: _body,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: _labelSpacing,
        height: 1.2,
        color: tertiaryColor,
      ),
    );
  }
}