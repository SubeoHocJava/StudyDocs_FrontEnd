import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/core/widgets/common/user_avatar.dart';


import '../../../../../screens/auth/presentation/cubit/auth_cubit.dart';
import '../../../../../screens/auth/presentation/cubit/auth_state.dart';
import '../../../../../screens/auth/presentation/widgets/auth_dialog.dart';
import '../domain/repository/menu_profile_repository.dart';
import '../domain/usecase/get_menu_profile_usecase.dart';
import '../logic/menu_profile_bloc.dart';
import 'widgets/activity_statistics.dart';
import 'widgets/upload_box.dart';

class MenuDrawer extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback? onLogoTap;
  final int selectedIndex;

  const MenuDrawer({
    super.key,
    required this.onClose,
    this.onLogoTap,
    this.selectedIndex = -1,
  });

  void _navigateTo(BuildContext context, int index) {
    if (index == 1 || index == 3) {
      final authState = context.read<AuthCubit>().state;
      if (authState is! AuthAuthenticated) {
        onClose();
        showAuthDialog(context);
        return;
      }
    }

    onClose();

    switch (index) {
      case 0:
        context.go("/home");
        break;
      case 1:
        context.go("/library");
        break;
      case 2:
        context.go("/explore");
        break;
      case 3:
        context.go("/notifications");
        break;
      default:
        context.go("/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final isLoggedIn = authState is AuthAuthenticated;

    return BlocProvider(
      create: (_) {
        final bloc = MenuProfileBloc(GetMenuProfileUseCase(MenuProfileRepositoryImpl()));
        if (isLoggedIn) {
          bloc.add(LoadMenuProfile("me"));
        }
        return bloc;
      },
      child: Material(
        elevation: 16,
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        child: BlocBuilder<MenuProfileBloc, MenuProfileState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isLoggedIn) ...[
                          if (state is MenuProfileLoaded) _buildUserInfo(state),
                          if (state is MenuProfileLoading)
                            const Center(child: CircularProgressIndicator()),
                          if (state is MenuProfileError)
                            Text('Lỗi: ${state.message}'),

                          const SizedBox(height: 24),

                          if (state is MenuProfileLoaded)
                            ActivityStatistics(
                              numMyUpload: state.profile.numMyUpload,
                              numMyLikes: state.profile.numMyLikes,
                              numMyComment: state.profile.numMyComment,
                            ),

                          const SizedBox(height: 24),
                        ] else ...[
                          _buildGuestInfo(context),
                          const SizedBox(height: 24),
                        ],

                        _buildMenuItem(
                          context,
                          icon: Icons.home,
                          title: 'Trang chủ',
                          isActive: selectedIndex == 0,
                          onTap: () => _navigateTo(context, 0),
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.library_books,
                          title: 'Thư viện',
                          isActive: selectedIndex == 1,
                          onTap: () => _navigateTo(context, 1),
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.lightbulb_outline,
                          title: 'Khám phá',
                          isActive: selectedIndex == 2,
                          onTap: () => _navigateTo(context, 2),
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.notifications_none,
                          title: 'Thông báo',
                          isActive: selectedIndex == 3,
                          onTap: () => _navigateTo(context, 3),
                        ),

                        // QR Scan
                        _buildMenuItem(
                          context,
                          icon: Icons.qr_code_scanner,
                          title: 'Quét QR',
                          onTap: () {
                            onClose();
                            // context.push(AppRoutes.qrScan);
                          },
                        ),

                        // Admin context
                        // BlocBuilder<AuthStatusCubit, AuthStatus>(
                        //   builder: (context, authState) {
                        //     if (authState is AuthAuthenticated &&
                        //         authState.isAdmin) {
                        //       return _buildMenuItem(
                        //         context,
                        //         icon: Icons.admin_panel_settings_outlined,
                        //         title: 'Quản lý admin',
                        //         isActive: false,
                        //         onTap: () {
                        //           onClose();
                        //           context.push(AppRoutes.adminDashboard);
                        //         },
                        //       );
                        //     }
                        //     return const SizedBox.shrink();
                        //   },
                        // ),

                        // ...
                        const SizedBox(height: 24),
                        const UploadBox(),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                    if (authState is! AuthAuthenticated) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      child: _buildMenuItem(
                        context,
                        icon: Icons.logout,
                        title: 'Đăng xuất',
                        onTap: () async {
                          onClose();
                          await context.read<AuthCubit>().logout();
                          if (context.mounted) {
                            context.go('/home');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đã đăng xuất'),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGuestInfo(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(AppAssets.user, width: 56, height: 56),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Khách",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () {
                  onClose();
                  showAuthDialog(context);
                },
                child: const Text(
                  "Đăng nhập ngay",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo(MenuProfileLoaded state) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            onClose();
            // context.push(AppRoutes.profile);
          },
          child: Row(
            children: [
              UserAvatar(
                avatarUrl: state.profile.avatarUrl,
                radius: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.profile.fullName.isNotEmpty
                          ? state.profile.fullName
                          : state.profile.userName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (state.profile.school != null && state.profile.school!.isNotEmpty)
                          ? state.profile.school!
                          : "Chưa có trường học",
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).hintColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        bool isActive = false,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        hoverColor: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isActive ? Theme.of(context).colorScheme.primaryContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).iconTheme.color?.withValues(alpha: 0.7),
                size: 24,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}