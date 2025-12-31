import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasource/auth_remote_datasource_hybrid.dart';
import '../../features/auth/domain/repositories/impl/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/google_login_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../theme/app_theme.dart';
import '../constants/app_colors.dart';
import '../constants/app_icons.dart';
import 'app_icon_button.dart';
import '../../features/auth/presentation/widgets/login_modal.dart';
import '../../features/auth/presentation/bloc/login_bloc.dart';
import 'package:studydocs/features/auth/presentation/bloc/register_bloc.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onLogoTap;
  final VoidCallback? onLoginTap;

  const Header({super.key, this.onMenuTap, this.onLogoTap, this.onLoginTap});

  void _showLoginModal(BuildContext context) {
    // Hiển thị dialog đăng nhập với hiệu ứng chuẩn Material.
    // Ở đây chúng ta khởi tạo chuỗi phụ thuộc: DataSource -> Repository -> UseCase -> BLoC
    // tương tự như phần Home, nhưng rút gọn để dễ hiểu.

    // 1. Tầng data: login/register dùng mock, Google login dùng thật
    final remote = AuthRemoteDataSourceHybrid();

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
      builder:
          (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create:
                    (_) => LoginBloc(
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

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeController>();

    return Container(
      height: kToolbarHeight,
      decoration: const BoxDecoration(color: AppColors.headerBackground),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9.0),
          child: Row(
            children: [
              AppIconButton(
                iconData: Icons.menu,
                color: AppColors.headerForeground,
                onPressed: onMenuTap ?? () {},
                size: 24,
              ),

              const SizedBox(width: 12),

              GestureDetector(
                onTap: onLogoTap ?? () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo image
                    Image.asset(AppAssets.logo, width: 60, height: 60),
                    const SizedBox(width: 12),
                  ],
                ),
              ),

              const Spacer(),

              // Login button and sun icon on the right
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Login button
                  ElevatedButton(
                    onPressed: onLoginTap ?? () => _showLoginModal(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.headerForeground,
                      foregroundColor: AppColors.headerBackground,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    child: const Text('Đăng nhập'),
                  ),

                  const SizedBox(width: 8),

                  // Sun/brightness icon
                  AppIconButton(
                    iconData: Icons.wb_sunny_outlined,
                    color: AppColors.headerForeground,
                    onPressed: () => theme.toggle(),
                    size: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
