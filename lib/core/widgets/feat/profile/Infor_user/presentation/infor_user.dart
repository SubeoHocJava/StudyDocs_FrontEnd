import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/constants/app_colors.dart';

import '../../../../../router/app_router.dart';

import '../../setting/logic/setting_bloc.dart';
import '../../setting/presentation/setting_dialog.dart';
import '../logic/infor_user_bloc.dart';
import '../logic/infor_user_event.dart';
import '../logic/infor_user_state.dart';
import 'package:studydocs/screens/profile/logic/profile_bloc.dart';
import 'package:studydocs/screens/profile/logic/profile_event.dart';
import 'package:studydocs/screens/auth/presentation/cubit/auth_cubit.dart';
import 'package:studydocs/screens/auth/presentation/cubit/auth_state.dart';
import 'package:studydocs/screens/auth/presentation/widgets/auth_dialog.dart';

class InforUser extends StatelessWidget {
  const InforUser({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InforUserBloc, InforUserState>(
      listener: (context, state) {
        if (state is InforUserLoaded && state.isOwnProfile) {
          final authState = context.read<AuthCubit>().state;
          if (authState is AuthAuthenticated) {
            // Update AuthCubit avatar if it has changed in InforUserBloc
            if (state.avatarUrl != null && state.avatarUrl != authState.avatarUrl) {
              context.read<AuthCubit>().updateUserAvatar(state.avatarUrl!);
            }
          }
        }
      },
      builder: (context, state) {
        if (state is InforUserLoading || state is InforUserInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is InforUserError) {
          return Center(child: Text("Lỗi: ${state.message}"));
        }

        if (state is! InforUserLoaded) {
          return const Center(child: Text("Không có dữ liệu"));
        }

        return _buildContent(context, state);
      },
    );
  }

  Widget _buildContent(BuildContext context, InforUserLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// ============ AVATAR =============
          _buildAvatar(
            context: context,
            avatarUrl: state.avatarUrl,
            isOwnProfile: state.isOwnProfile,
          ),

          const SizedBox(height: 14),

          /// ============ NAME =============
          Text(
            state.fullName.isNotEmpty ? state.fullName : "Tên chưa cập nhật",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 6),

          /// ============ SCHOOL =============
          Text(
            state.school?.isNotEmpty == true
                ? state.school!
                : "Chưa có trường học",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          /// ============ NÚT ACTION =============
          _buildActionButton(context, state),
        ],
      ),
    );
  }

  // ================= AVATAR =================
  Widget _buildAvatar({
    required BuildContext context,
    required String? avatarUrl,
    required bool isOwnProfile,
  }) {
    return GestureDetector(
      onTap:
          isOwnProfile
              ? () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.image,
                  withData: true,
                );
                if (result == null || result.files.isEmpty) return;

                final file = result.files.single;

                if (!context.mounted) return;

                final confirm = await showDialog<bool>(
                  context: context,
                  builder:
                      (ctx) => AlertDialog(
                        title: const Text("Xác nhận cập nhật ảnh đại diện"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (file.bytes != null)
                              ClipOval(
                                child: Image.memory(
                                  file.bytes!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            const SizedBox(height: 16),
                            const Text(
                              "Bạn có muốn sử dụng ảnh này làm ảnh đại diện không?",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text("Hủy"),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text("Đồng ý"),
                          ),
                        ],
                      ),
                );

                if (confirm == true && context.mounted) {
                  context.read<InforUserBloc>().add(UpdateUserAvatar(file));
                }
              }
              : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              image: _avatarImageProvider(avatarUrl),
            ),
            child:
                (avatarUrl == null || avatarUrl.isEmpty)
                    ? Icon(
                      Icons.person,
                      size: 70,
                      color: Theme.of(context).iconTheme.color,
                    )
                    : null,
          ),

          if (isOwnProfile)
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.camera_alt, size: 18, color: AppColors.white),
              ),
            ),
        ],
      ),
    );
  }

  DecorationImage? _avatarImageProvider(String? image) {
    if (image == null || image.isEmpty) return null;

    if (image.startsWith("http")) {
      return DecorationImage(image: NetworkImage(image), fit: BoxFit.cover);
    }

    return DecorationImage(image: AssetImage(image), fit: BoxFit.cover);
  }

  // ================= ACTION BUTTON =================
  Widget _buildActionButton(BuildContext context, InforUserLoaded state) {
    if (state.isOwnProfile) {
      return OutlinedButton.icon(
        onPressed: () async {
          final result = await showGlobalDialog(
            BlocProvider(
              create: (_) => SettingBloc(),
              child: const SettingDialog(),
            ),
          );
          if (result == true && context.mounted) {
            context.read<ProfileBloc>().add(ProfileInitial("me"));
          }
        },
        icon: const Icon(Icons.settings, size: 18),
        label: const Text("Cài đặt"),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }

    final isAuthenticated = context.read<AuthCubit>().state is AuthAuthenticated;

    if (state.isFollowing) {
      return OutlinedButton.icon(
        onPressed: () {
          if (!isAuthenticated) {
            showAuthDialog(context);
            return;
          }
          context.read<InforUserBloc>().add(UnfollowUserEvent(state.id));
        },
        icon: Icon(
          Icons.person_remove,
          size: 18,
          color: Theme.of(context).disabledColor,
        ),
        label: Text(
          "Bỏ theo dõi",
          style: TextStyle(color: Theme.of(context).disabledColor),
        ),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(color: Theme.of(context).disabledColor),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: () {
        if (!isAuthenticated) {
          showAuthDialog(context);
          return;
        }
        context.read<InforUserBloc>().add(FollowUserEvent(state.id));
      },
      icon: Icon(
        Icons.person_add,
        size: 18,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      label: Text(
        "Theo dõi",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
