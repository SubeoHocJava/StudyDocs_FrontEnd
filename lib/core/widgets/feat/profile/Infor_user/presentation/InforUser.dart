
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/constants/app_colors.dart';

import '../../../../../router/app_router.dart';
import '../../../../../router/app_routes_list.dart';
import '../../setting/logic/setting_bloc.dart';
import '../../setting/presentation/SettingDialog.dart';
import '../logic/InforUserBloc.dart';
import '../logic/InforUserEvent.dart';
import '../logic/InforUserState.dart';

class InforUser extends StatelessWidget {
  const InforUser({super.key});

  @override
  Widget build(BuildContext context) {
    return
    BlocBuilder<InforUserBloc, InforUserState>(
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
      // ),
    );
  }

  Widget _buildContent(BuildContext context, InforUserLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// ============ NÚT ACTION =============
          Align(
            alignment: Alignment.topRight,
            child: _buildActionButton(context, state),
          ),

          const SizedBox(height: 10),

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
                if (result == null) return;

                context.read<InforUserBloc>().add(
                  UpdateUserAvatar(result.files.single),
                );
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
                child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
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
      return TextButton.icon(
        onPressed: () {
          showGlobalDialog(
            BlocProvider(
              create: (_) => SettingBloc(),
              child: const SettingDialog(),
            ),
          );
        },
        icon: const Icon(Icons.settings, size: 18),
        label: const Text("Cài đặt"),
      );
    }

    return TextButton.icon(
      onPressed: () {
        if (state.isFollowing) {
          context.read<InforUserBloc>().add(UnfollowUserEvent(state.id));
        } else {
          context.read<InforUserBloc>().add(FollowUserEvent(state.id));
        }
      },
      icon: Icon(
        state.isFollowing ? Icons.person_remove : Icons.person_add,
        size: 18,
        color:
            state.isFollowing
                ? Theme.of(context).disabledColor
                : Theme.of(context).colorScheme.primary,
      ),
      label: Text(
        state.isFollowing ? "Bỏ theo dõi" : "Theo dõi",
        style: TextStyle(
          color:
              state.isFollowing
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).colorScheme.primary,
        ),
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color:
                state.isFollowing
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
