import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/data/datasource/impl/auth_remote_datasource_impl.dart';
import 'package:studydocs/data/datasource/impl/auth_remote_datasource_hybrid.dart';
import 'package:studydocs/features/auth/domain/repositories/impl/auth_repository_impl.dart';
import 'package:studydocs/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:studydocs/features/auth/domain/usecases/login_usecase.dart';
import 'package:studydocs/features/auth/domain/usecases/register_usecase.dart';
import 'package:studydocs/features/auth/presentation/widgets/login_modal.dart';
import 'package:studydocs/features/auth/presentation/bloc/login_bloc.dart';
import 'package:studydocs/features/auth/presentation/bloc/register_bloc.dart';

void showLoginModal(BuildContext context) {
  // 1. Tầng data: login/register dùng real API logic
  final dioClient = context.read<DioClient>();
  final impl = AuthRemoteDataSourceImpl(dioClient: dioClient);
  final remote = AuthRemoteDataSourceHybrid(implementation: impl);

  // 2. Tầng repository: wrap datasource
  final authRepository = AuthRepositoryImpl(remote: remote);

  // 3. Tầng domain: usecase đăng nhập
  final loginUseCase = LoginUseCase(repository: authRepository);
  final googleLoginUseCase = GoogleLoginUseCase(repository: authRepository);
  final registerUseCase = RegisterUseCase(repository: authRepository);

  // 4. Cung cấp [LoginBloc] riêng cho dialog thông qua BlocProvider.
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LoginBloc(
            loginUseCase: loginUseCase,
            googleLoginUseCase: googleLoginUseCase,
          ),
        ),
        BlocProvider(
          create: (_) => RegisterBloc(registerUseCase: registerUseCase),
        ),
      ],
      child: const LoginModal(),
    ),
  );
}
