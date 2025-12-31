import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/home/logic/home_bloc.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/library/presentation/screen/library_screen.dart';

import 'package:studydocs/features/main/main_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: Consumer<ThemeController>(
        builder: (context, themeController, child) {
          return MaterialApp(
            title: 'StudyDocs',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeController.mode,

            // màn hình đầu tiên khi mở app
            home: BlocProvider(
              create: (context) => createHomeBloc(),
              child: const MainScreen(),
            ),

          );
        },
      ),
    );
  }
}
