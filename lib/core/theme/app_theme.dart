import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode mode = ThemeMode.light;
  void toggle() {
    mode = mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class AppTheme {
  static ThemeData _baseLight() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.headerBackground,
        foregroundColor: AppColors.headerForeground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.headerForeground),
      ),
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.headerForeground,
        secondary: AppColors.profileSchool,
      ),
      textTheme: GoogleFonts.montserratTextTheme(base.textTheme),
    );
  }

  static ThemeData _baseDark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.headerForeground,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      colorScheme: base.colorScheme.copyWith(
        primary: Colors.white,
        secondary: AppColors.profileSchool,
      ),
      textTheme: GoogleFonts.montserratTextTheme(base.textTheme),
    );
  }

  static ThemeData get lightTheme => _baseLight();
  static ThemeData get darkTheme => _baseDark();
}
