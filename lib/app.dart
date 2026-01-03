import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/home/logic/home_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = createAppRouter();

    return ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: Consumer<ThemeController>(
        builder: (context, themeController, child) {
          return MaterialApp.router(
            title: 'StudyDocs',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeController.mode,

            routerConfig: router,
            builder: (context, child) {
              // Keep a single HomeBloc instance for the whole app (previously provided at home).
              return BlocProvider(
                create: (context) => createHomeBloc(),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
