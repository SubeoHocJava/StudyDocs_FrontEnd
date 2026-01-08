import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/home/logic/home_bloc.dart';
import 'features/auth/presentation/bloc/auth_status_cubit.dart';
import 'core/router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
            routerConfig: createAppRouter(),
            builder: (context, child) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                     create: (context) => createHomeBloc(),
                  ),
                  BlocProvider(
                    create: (_) => AuthStatusCubit()..setAuthenticated('fake_bypass_token'),
                  ),
                ],
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}