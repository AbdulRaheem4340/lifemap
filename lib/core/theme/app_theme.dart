import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.lightPrimaryLight,
      onPrimaryContainer: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.lightSecondary.withValues(alpha: 0.15),
      onSecondaryContainer: AppColors.lightSecondary,
      error: AppColors.error,
      onError: AppColors.white,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      surfaceContainerHighest: AppColors.lightBackground,
      onSurfaceVariant: AppColors.lightTextSecondary,
      outline: AppColors.lightTextTertiary,
      outlineVariant: AppColors.lightTextTertiary.withValues(alpha: 0.3),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: AppTypography.buildTextTheme(AppColors.lightTextPrimary),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.lightTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: AppTypography.buildTextTheme(AppColors.lightTextPrimary)
            .titleLarge,
        iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 1,
        shadowColor: AppColors.lightPrimary.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.white,
          elevation: 2,
          shadowColor: AppColors.lightPrimary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: AppTypography.buildTextTheme(AppColors.white).labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightPrimary,
          side: const BorderSide(color: AppColors.lightPrimary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.lightPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.lightSurface,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        dragHandleColor: AppColors.lightTextTertiary,
        dragHandleSize: const Size(40, 4),
        showDragHandle: true,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        hintStyle: AppTypography.buildTextTheme(AppColors.lightTextTertiary)
            .bodyMedium,
        labelStyle: AppTypography.buildTextTheme(AppColors.lightTextSecondary)
            .bodyMedium,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightTextPrimary,
        contentTextStyle: AppTypography.buildTextTheme(AppColors.white)
            .bodyMedium,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        indicatorColor: AppColors.lightPrimary.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.lightPrimary);
          }
          return const IconThemeData(color: AppColors.lightTextTertiary);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final base = AppTypography.buildTextTheme(
            AppColors.lightTextSecondary,
          ).labelSmall!;
          if (states.contains(WidgetState.selected)) {
            return base.copyWith(color: AppColors.lightPrimary);
          }
          return base;
        }),
        elevation: 0,
        surfaceTintColor: AppColors.transparent,
      ),

      dividerTheme: DividerThemeData(
        color: AppColors.lightTextTertiary.withValues(alpha: 0.2),
        thickness: 1,
        space: 1,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightPrimary.withValues(alpha: 0.1),
        labelStyle: AppTypography.buildTextTheme(AppColors.lightPrimary)
            .labelMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: AppTypography.buildTextTheme(AppColors.lightTextPrimary)
            .headlineMedium,
        contentTextStyle: AppTypography.buildTextTheme(
          AppColors.lightTextSecondary,
        ).bodyMedium,
      ),
    );
  }

  static ThemeData get dark {
    final ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkBackground,
      primaryContainer: AppColors.darkPrimaryLight,
      onPrimaryContainer: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkBackground,
      secondaryContainer: AppColors.darkSecondary.withValues(alpha: 0.15),
      onSecondaryContainer: AppColors.darkSecondary,
      error: AppColors.darkAccent,
      onError: AppColors.white,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      surfaceContainerHighest: AppColors.darkBackground,
      onSurfaceVariant: AppColors.darkTextSecondary,
      outline: AppColors.darkTextTertiary,
      outlineVariant: AppColors.darkTextTertiary.withValues(alpha: 0.3),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: AppTypography.buildTextTheme(AppColors.darkTextPrimary),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.buildTextTheme(AppColors.darkTextPrimary)
            .titleLarge,
        iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.white.withValues(alpha: 0.08), width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkBackground,
          elevation: 4,
          shadowColor: AppColors.darkPrimary.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: AppTypography.buildTextTheme(AppColors.darkBackground)
              .labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          side: const BorderSide(color: AppColors.darkPrimary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkBackground,
        elevation: 6,
        shape: CircleBorder(),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          side: BorderSide(color: AppColors.white.withValues(alpha: 0.08), width: 1),
        ),
        dragHandleColor: AppColors.darkTextTertiary,
        dragHandleSize: const Size(40, 4),
        showDragHandle: true,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkBackground.withValues(alpha: 0.6),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkAccent, width: 1.5),
        ),
        hintStyle: AppTypography.buildTextTheme(AppColors.darkTextTertiary)
            .bodyMedium,
        labelStyle: AppTypography.buildTextTheme(AppColors.darkTextSecondary)
            .bodyMedium,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurface,
        contentTextStyle: AppTypography.buildTextTheme(
          AppColors.darkTextPrimary,
        ).bodyMedium,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.white.withValues(alpha: 0.08)),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        indicatorColor: AppColors.darkPrimary.withValues(alpha: 0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.darkPrimary);
          }
          return const IconThemeData(color: AppColors.darkTextTertiary);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final base = AppTypography.buildTextTheme(AppColors.darkTextSecondary)
              .labelSmall!;
          if (states.contains(WidgetState.selected)) {
            return base.copyWith(color: AppColors.darkPrimary);
          }
          return base;
        }),
        elevation: 0,
        surfaceTintColor: AppColors.transparent,
      ),

      dividerTheme: DividerThemeData(
        color: AppColors.white.withValues(alpha: 0.06),
        thickness: 1,
        space: 1,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkPrimary.withValues(alpha: 0.15),
        labelStyle: AppTypography.buildTextTheme(AppColors.darkPrimary)
            .labelMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.white.withValues(alpha: 0.08)),
        ),
        titleTextStyle: AppTypography.buildTextTheme(AppColors.darkTextPrimary)
            .headlineMedium,
        contentTextStyle: AppTypography.buildTextTheme(
          AppColors.darkTextSecondary,
        ).bodyMedium,
      ),
    );
  }
}

