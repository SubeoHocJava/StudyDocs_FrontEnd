import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/theme/theme_cubit.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/constants/app_dark_colors.dart';
class MyApp extends StatefulWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: AppColors.backgroundLight,
            cardColor: AppColors.white,
            dialogTheme: const DialogThemeData(backgroundColor: AppColors.white),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.headerBackground,
              foregroundColor: AppColors.headerForeground,
            ),
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              secondary: AppColors.secondaryBlue,
              surface: AppColors.surfaceLight,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: AppDarkColors.background,
            cardColor: AppDarkColors.surface,
            dialogTheme: const DialogThemeData(backgroundColor: AppDarkColors.surface),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.backgroundNavy,
              foregroundColor: AppDarkColors.textPrimary,
            ),
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              secondary: AppColors.secondaryTeal,
              surface: AppDarkColors.surface,
            ),
          ),
          routerConfig: widget.router,
        );
      }
    );
  }
}
