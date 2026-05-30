import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'core/network/dio_client.dart';
import 'core/router/app_router.dart';
import 'features/auth/data/auth_service.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final authService = AuthService();
  final authCubit = AuthCubit(authService: authService);

  DioClient().configureAuth(
    authService: authService,
    onSessionExpired: authCubit.sessionExpired,
  );

  await authCubit.checkSession();

  final router = initAppRouter();
  runApp(
    BlocProvider.value(
      value: authCubit,
      child: MyApp(router: router),
    ),
  );
}
