import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        tertiary: AppColors.secondary,
        background: AppColors.background,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme.copyWith(
          displayLarge: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          displayMedium: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          headlineLarge: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          headlineMedium: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          bodyLarge: const TextStyle(color: AppColors.textPrimary),
          bodyMedium: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
    );
  }
}
