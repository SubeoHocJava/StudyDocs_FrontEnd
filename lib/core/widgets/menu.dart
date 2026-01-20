import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/auth/presentation/bloc/auth_status_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/widgets/upload_box.dart';
import 'package:studydocs/features/profile/domain/repository/impl/ProfileRepositoryImpl.dart';
import 'package:studydocs/features/profile/logic/profile_bloc.dart';
import 'package:studydocs/features/profile/logic/profile_event.dart';
import 'package:studydocs/features/profile/logic/profile_state.dart';
import 'package:studydocs/features/profile/presentation/widget/Statistical.dart';
import 'package:studydocs/core/router/app_router.dart';
import 'package:studydocs/core/constants/app_icons.dart';

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
    onClose();

    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.library);
        break;
      case 2:
        context.go(AppRoutes.explore);
        break;
      case 3:
        context.go(AppRoutes.notifications);
        break;
      default:
        context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthStatusCubit>().state;
    String userId = '';
    if (authState is AuthAuthenticated) {
      userId = authState.userId;
    }

    return BlocProvider(
      create: (_) {
        final bloc = ProfileBloc(ProfileRepositoryImpl());
        if (userId.isNotEmpty) {
          bloc.add(LoadProfile(userId));
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
        child: BlocBuilder<ProfileBloc, ProfileState>(
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
                        if (state is ProfileLoaded) _buildUserInfo(state),
                        if (state is ProfileLoading)
                          const Center(child: CircularProgressIndicator()),
                        if (state is ProfileError)
                          Text('Lỗi: ${state.message}'),

                        const SizedBox(height: 24),

                        if (state is ProfileLoaded)
                          ActivityStatistics(
                            numMyUpload: state.numMyUpload,
                            numMyLikes: state.numMyLikes,
                            numMyComment: state.numMyComment,
                          ),

                        const SizedBox(height: 24),

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
                             context.push(AppRoutes.qrScan);
                          },
                        ),

                        // Admin context
                        BlocBuilder<AuthStatusCubit, AuthStatus>(
                          builder: (context, authState) {
                            if (authState is AuthAuthenticated &&
                                authState.isAdmin) {
                              return _buildMenuItem(
                                context,
                                icon: Icons.admin_panel_settings_outlined,
                                title: 'Quản lý admin',
                                isActive: false,
                                onTap: () {
                                  onClose();
                                  context.push(AppRoutes.adminDashboard);
                                },
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),

                        // ...
                        const SizedBox(height: 24),
                        const UploadBox(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserInfo(ProfileLoaded state) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            onClose();
            context.push(AppRoutes.profile);
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage:
                    (state.avatarUrl != null && state.avatarUrl!.isNotEmpty)
                        ? NetworkImage(state.avatarUrl!)
                        : const AssetImage(AppAssets.avt) as ImageProvider,
                child: null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.fullName.isNotEmpty
                          ? state.fullName
                          : state.userName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (state.school != null && state.school!.isNotEmpty)
                          ? state.school!
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
        hoverColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
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
                color: isActive ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).iconTheme.color?.withOpacity(0.7),
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
