import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:studydocs/screens/auth/data/auth_service.dart';
import 'package:studydocs/screens/auth/presentation/cubit/auth_cubit.dart';
import 'package:studydocs/core/widgets/feat/document/docs_card/logic/document_sync_cubit.dart';
import 'app.dart';
import 'core/network/dio_client.dart';
import 'core/router/app_router.dart';


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
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authCubit),
        BlocProvider(create: (_) => DocumentSyncCubit()),
      ],
      child: MyApp(router: router),
    ),
  );
}
