import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/home/logic/home_bloc.dart';
import 'features/auth/presentation/bloc/auth_status_cubit.dart';

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
              // Provide global BLoCs/Cubits for the whole app
              return MultiBlocProvider(
                providers: [
                  // HomeBloc instance for the whole app
                  BlocProvider(
                    create: (context) => createHomeBloc(),
                  ),
                  // AuthStatusCubit để quản lý trạng thái login toàn app
                  BlocProvider(
                    create: (context) => AuthStatusCubit()..checkAuthStatus(),
                  ),
                ],
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
