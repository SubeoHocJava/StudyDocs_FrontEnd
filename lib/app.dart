import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/logic/theme_bloc.dart';
import 'core/theme/logic/theme_state.dart';
import 'core/theme/domain/repository/theme_repository.dart';
import 'features/home/logic/home_bloc.dart';
import 'features/auth/presentation/bloc/auth_status_cubit.dart';
import 'features/notification/service/fcm_service.dart';
import 'core/router/app_router.dart';

final _router = createAppRouter();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createAppRouter();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(
        themeRepository: context.read<ThemeRepository>(),
      ),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'StudyDocs',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,
            routerConfig: _router,
            builder: (context, child) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                     create: (context) => createHomeBloc(),
                  ),
                  BlocProvider(
                    create: (_) => AuthStatusCubit(),
                  ),
                ],
                child: BlocListener<AuthStatusCubit, AuthStatus>(
                  listener: (context, state) {
                    if (state is AuthAuthenticated) {
                      // Khi user login thành công (hoặc auto login), đăng ký FCM token
                      FcmService().registerCurrentToken();
                    }
                  },
                  child: child!,
                ),
              );
            },
          );
        },
      ),
    );
  }
}