import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/widgets/upload_box.dart';
import 'package:studydocs/features/profile/domain/repository/impl/ProfileRepositoryImpl.dart';
import 'package:studydocs/features/profile/logic/profile_bloc.dart';
import 'package:studydocs/features/profile/logic/profile_event.dart';
import 'package:studydocs/features/profile/logic/profile_state.dart';
import 'package:studydocs/features/profile/presentation/screen/profile_screen.dart';
import 'package:studydocs/features/profile/presentation/widget/Statistical.dart';
import 'package:studydocs/core/router/app_router.dart';

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
    return BlocProvider(
      create:
          (_) =>
              ProfileBloc(ProfileRepositoryImpl())..add(const LoadProfile(0)),
      child: Material(
        elevation: 16,
        color: Colors.white,
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage:
                    state.avatarUrl != null
                        ? NetworkImage(state.avatarUrl!)
                        : null,
                child:
                    state.avatarUrl == null ? const Icon(Icons.person) : null,
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.profileName,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.school,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryBlue,
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
        hoverColor: AppColors.primaryLight.withOpacity(0.5),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryLight : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive ? AppColors.primary : AppColors.docSmallText,
                size: 24,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isActive ? AppColors.primary : AppColors.profileName,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
