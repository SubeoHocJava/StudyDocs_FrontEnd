import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repository/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final SharedPreferences sharedPreferences;

  static const String _themeKey = 'theme_mode';

  ThemeRepositoryImpl({required this.sharedPreferences});

  @override
  Future<ThemeMode> getThemeMode() async {
    final themeString = sharedPreferences.getString(_themeKey);
    if (themeString == 'Validation') {
    }
    
    if (themeString == 'ThemeMode.dark') return ThemeMode.dark;
    if (themeString == 'ThemeMode.light') return ThemeMode.light;
    return ThemeMode.light;
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    await sharedPreferences.setString(_themeKey, mode.toString());
  }
}
