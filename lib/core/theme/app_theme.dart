import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData _baseLight() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.headerBackground,
        foregroundColor: AppColors.headerForeground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.headerForeground),
      ),
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.secondaryBlue,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight, // Keep as is
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.primary,
      ),
      hintColor: AppColors.textSecondaryLight,
      unselectedWidgetColor: AppColors.gray,
      dividerColor: AppColors.divider,
      shadowColor: AppColors.shadow.withOpacity(0.1),
      cardTheme: const CardThemeData(color: AppColors.surfaceLight),
      textTheme: GoogleFonts.montserratTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: AppColors.textPrimaryLight,
        displayColor: AppColors.textPrimaryLight,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        hintStyle: TextStyle(color: AppColors.textSecondaryLight),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  static ThemeData _baseDark() {
    final base = ThemeData.dark(useMaterial3: true);
    
    final textTheme = GoogleFonts.montserratTextTheme(ThemeData.light().textTheme);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.white,
        centerTitle: true,
        elevation: 0,
      ),
      iconTheme: const IconThemeData(color: AppColors.white),
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.secondaryBlue,
        secondary: AppColors.secondaryTeal,
        surface: AppColors.backgroundDark,
        onSurface: AppColors.white,
        tertiary: AppColors.secondaryTeal,
        primaryContainer: AppColors.secondaryBlue, 
        onPrimaryContainer: AppColors.navy,
      ),
      hintColor: AppColors.textSecondaryDark,
      unselectedWidgetColor: AppColors.gray,
      dividerColor: AppColors.gray,
      shadowColor: Colors.black.withOpacity(0.5),
      cardTheme: const CardThemeData(
        color: AppColors.backgroundDark,
        shadowColor: Colors.black54,
        elevation: 4,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        hintStyle: const TextStyle(color: AppColors.textSecondaryDark),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.gray.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.gray.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.secondaryBlue, width: 2),
        ),
      ),
      textTheme: textTheme.apply(
        bodyColor: AppColors.textPrimaryDark,
        displayColor: AppColors.textPrimaryDark,
        decorationColor: AppColors.textPrimaryDark,
      ).copyWith(
        bodySmall: textTheme.bodySmall?.copyWith(color: AppColors.textSecondaryDark, fontSize: 12),
        bodyMedium: textTheme.bodyMedium?.copyWith(color: AppColors.white),
        bodyLarge: textTheme.bodyLarge?.copyWith(color: AppColors.white),
        titleLarge: textTheme.titleLarge?.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  static ThemeData get lightTheme => _baseLight();
  static ThemeData get darkTheme => _baseDark();
}
