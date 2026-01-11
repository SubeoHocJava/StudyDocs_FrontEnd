import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/router/app_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/menu.dart';

import '../../data/datasource/auth_mock_datasource_impl.dart';
import '../theme/app_theme.dart';
import '../constants/app_colors.dart';
import '../constants/app_icons.dart';
import 'app_icon_button.dart';

//hao
import '../../features/auth/domain/repositories/impl/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/google_login_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/widgets/login_modal.dart';
import '../../features/auth/presentation/bloc/login_bloc.dart';
import 'package:studydocs/features/auth/presentation/bloc/register_bloc.dart';
import '../../features/auth/presentation/bloc/auth_status_cubit.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onLogoTap;
  final VoidCallback? onLoginTap;
  final VoidCallback? onFollowTap;
  final VoidCallback? onProfileTap;

  // New properties from user
  final bool isDefault;
  final String? headerTitle;
  final VoidCallback? onBack;
  final void Function(BuildContext)? onModal;
  final int selectedIndex;

  const Header({
    super.key,
    this.onMenuTap,
    this.onLogoTap,
    this.onLoginTap,
    this.onFollowTap,
    this.onProfileTap,
    this.isDefault = true,
    this.headerTitle,
    this.onBack,
    this.onModal,
    this.selectedIndex = -1,
  });

  @override
  State<Header> createState() => _HeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(90);
}

class _HeaderState extends State<Header> {
  OverlayEntry? _overlayEntry;
  bool _isMenuOpen = false;

  //auth
  void _showLoginModal(BuildContext context) {
    // Hiển thị dialog đăng nhập với hiệu ứng chuẩn Material.
    // Ở đây chúng ta khởi tạo chuỗi phụ thuộc: DataSource -> Repository -> UseCase -> BLoC
    // tương tự như phần Home, nhưng rút gọn để dễ hiểu.

    // 1. Tầng data: login/register dùng mock, Google login dùng thật
    final remote = AuthMockDataSourceImpl();

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

  void _toggleMenu() {
    if (_isMenuOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _closeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isMenuOpen = false;
    });
  }

  void _openMenu() {
    final overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              // Barrier
              Positioned.fill(
                top:
                    widget.preferredSize.height +
                    MediaQuery.of(context).padding.top,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque, // ← THÊM DÒNG NÀY
                  onTap: _closeMenu,
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
              ),
              // Drawer Content
              Positioned(
                top:
                    widget.preferredSize.height +
                    MediaQuery.of(context).padding.top,
                left: 0,
                bottom: 0,
                width: 300,
                child: MenuDrawer(
                  onClose: _closeMenu,
                  onLogoTap: widget.onLogoTap,
                  selectedIndex: widget.selectedIndex,
                ),
              ),
            ],
          ),
    );

    overlayState.insert(_overlayEntry!);
    setState(() {
      _isMenuOpen = true;
    });
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.headerBackground,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: widget.preferredSize.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left: Menu + Logo
                      Row(
                        children: [
                          _buildLeading(context),
                          const SizedBox(width: 12),
                          if (widget.isDefault) _buildLogo(),
                        ],
                      ),

                      if (!widget.isDefault && widget.headerTitle != null)
                        _buildTitle(),

                      _buildActions(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// LEFT: Menu Button or Back Button
  Widget _buildLeading(BuildContext context) {
    if (widget.isDefault) {
      return AppIconButton(
        iconData: Icons.menu,
        color: AppColors.headerForeground,
        onPressed: _toggleMenu,
        size: 24,
      );
    }

    return AppIconButton(
      iconData: Icons.arrow_back_ios_new,
      color: AppColors.headerForeground,
      onPressed: widget.onBack ?? () => Navigator.pop(context),
      size: 24,
    );
  }

  /// LOGO
  Widget _buildLogo() {
    return GestureDetector(
      onTap: () {
        if (widget.onLogoTap != null) {
          widget.onLogoTap!();
        } else {
          // Navigate to Home reset logic if needed
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Image.asset(AppAssets.logo, width: 56, height: 56),
    );
  }

  /// TITLE
  Widget _buildTitle() {
    return Text(
      widget.headerTitle ?? '',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.headerForeground,
        fontFamily: 'Montserrat',
      ),
    );
  }

  /// RIGHT ACTIONS
  Widget _buildActions(BuildContext context) {
    final theme = context.read<ThemeController>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.onModal != null) ...[
          AppIconButton(
            iconData: Icons.more_vert,
            color: AppColors.headerForeground,
            onPressed: () => widget.onModal?.call(context),
            size: 24,
          ),
        ],

        // Nếu có onProfileTap được truyền từ ngoài, ưu tiên dùng
        if (widget.onProfileTap != null) ...[
          AppIconButton(
            iconData: Icons.account_circle_outlined,
            color: AppColors.headerForeground,
            onPressed: widget.onProfileTap!,
            size: 28,
          ),
        ] else if (widget.isDefault) ...[
          // Lắng nghe AuthStatusCubit để hiển thị đúng UI
          BlocBuilder<AuthStatusCubit, AuthStatus>(
            builder: (context, authStatus) {
              if (authStatus is AuthAuthenticated) {
                // ĐÃ ĐĂNG NHẬP → Hiển thị profile icon
                return AppIconButton(
                  iconData: Icons.account_circle_outlined,
                  color: AppColors.headerForeground,
                  onPressed: () {
                    // Navigate to profile screen
                    context.push(AppRoutes.profile);
                  },
                  size: 28,
                );
              } else {
                // CHƯA ĐĂNG NHẬP → Hiển thị nút đăng nhập
                return ElevatedButton(
                  onPressed:
                      widget.onLoginTap ?? () => _showLoginModal(context),
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
                );
              }
            },
          ),
        ],
        const SizedBox(width: 8),
        AppIconButton(
          iconData: Icons.wb_sunny_outlined,
          color: AppColors.headerForeground,
          onPressed: () => theme.toggle(),
          size: 24,
        ),
      ],
    );
  }
}
