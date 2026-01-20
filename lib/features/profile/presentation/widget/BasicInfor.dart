import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'package:studydocs/features/profile/logic/profile_bloc.dart';
import 'package:studydocs/features/profile/logic/profile_state.dart';

import '../../../../features/auth/presentation/bloc/auth_status_cubit.dart';
import '../../logic/profile_event.dart';
import 'SettingBoard.dart';

class BasicInfor extends StatelessWidget {
  final ProfileLoaded state;

  const BasicInfor({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    // final image = "assets/icons/avt.png";
    final name = state.fullName;
    final school = state.school;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.widthPercent(5.0),
        vertical: responsive.heightPercent(2.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// ================= ACTION BUTTON =================
          Align(
            alignment: Alignment.topRight,
            child: _buildActionButton(context, responsive),
          ),

          SizedBox(height: responsive.heightPercent(1.0)),

          /// ================= AVATAR =================
          _buildAvatar(
            context,
            responsive,
            state.avatarUrl ?? '',
            onTap: () async {
              // Check if it's own profile before allowing update
              final authState = context.read<AuthStatusCubit>().state;
              if (authState is AuthAuthenticated && authState.userId == state.id) {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.image,
                  allowMultiple: false,
                );

                if (result == null) return;

                final file = result.files.single;
                if (file.path == null) return;

                context.read<ProfileBloc>().add(
                  UpdateAvatar(file),
                );
              }
            },
          ),

          SizedBox(height: responsive.heightPercent(1.5)),

          /// ================= NAME =================
          Text(
            name.isNotEmpty ? name : "Tên chưa cập nhật",
            style: TextStyle(
              fontSize: responsive.fontSize(18.0),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          /// ================= SCHOOL =================
          Text(
            (school != null && school.isNotEmpty)
                ? school
                : "Chưa có trường học",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: responsive.fontSize(15.0),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// ================= AVATAR BUTTON =================
  Widget _buildAvatar(
    BuildContext context,
    ResponsiveHelper responsive,
    String image, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: responsive.widthPercent(30.0),
            height: responsive.widthPercent(30.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: _buildAvatarImage(image),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child:
                image.isEmpty
                    ? Icon(
                      Icons.person,
                      size: responsive.widthPercent(20.0),
                      color: Theme.of(context).iconTheme.color,
                    )
                    : null,
          ),

          // overlay icon camera
          Positioned(
            bottom: 6,
            right: 6,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).shadowColor.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt,
                size: 16,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  DecorationImage? _buildAvatarImage(String image) {
    print("DEBUG: _buildAvatarImage input: '$image'");

    if (image.isEmpty) {
      print("DEBUG: Image string is empty");
      return null;
    }

    // Ảnh local (FilePicker)
    if (image.startsWith('/')) {
      print("DEBUG: Loading Local File: $image");
      return DecorationImage(
        image: FileImage(File(image)),
        fit: BoxFit.cover,
      );
    }

    // Ảnh từ network
    if (image.startsWith('http') || image.startsWith('https')) {
      print("DEBUG: Loading Network Image: $image");
      return DecorationImage(
        image: NetworkImage(image),
        fit: BoxFit.cover,
      );
    }

    // Ảnh asset
    if (image.startsWith('assets/')) {
      print("DEBUG: Loading Asset: $image");
      return DecorationImage(
        image: AssetImage(image),
        fit: BoxFit.cover,
      );
    }
    
    // Fallback cho trường hợp chuỗi không hợp lệ hoặc ID
    print("DEBUG: Fallback to default avatar (Input was: '$image')");
    return DecorationImage(
        image: AssetImage("assets/icons/avt.png"),
        fit: BoxFit.cover,
      );
  }

  /// ================= ACTION BUTTON =================
  Widget _buildActionButton(BuildContext context, ResponsiveHelper responsive) {
    final authState = context.read<AuthStatusCubit>().state;
    String? currentUserId;

    if (authState is AuthAuthenticated) {
      currentUserId = authState.userId;
    }

    final isOwnProfile = state.id == currentUserId;

    /// ===== OWNER =====
    if (isOwnProfile) {
      return TextButton.icon(
        onPressed: () => _showSettingBoard(context),
        icon: Icon(Icons.settings, size: responsive.fontSize(16.0)),
        label: Text(
          "Cài đặt",
          style: TextStyle(fontSize: responsive.fontSize(13.0)),
        ),
      );
    }

    /// ===== OTHER USER =====
    final isFollowing = state.isFollowing;

    return TextButton.icon(
      onPressed: () {
        context.read<ProfileBloc>().add(
          isFollowing ? UnfollowUser(state.id) : FollowUser(state.id),
        );
      },
      icon: Icon(
        isFollowing ? Icons.person_remove : Icons.person_add,
        size: responsive.fontSize(16.0),
        color: isFollowing ? Theme.of(context).disabledColor : Theme.of(context).colorScheme.primary,
      ),
      label: Text(
        isFollowing ? "Bỏ theo dõi" : "Theo dõi",
        style: TextStyle(
          fontSize: responsive.fontSize(13.0),
          color: isFollowing ? Theme.of(context).disabledColor : Theme.of(context).colorScheme.primary,
        ),
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: isFollowing ? Theme.of(context).disabledColor : Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

/// ================= SETTINGS DIALOG =================
void _showSettingBoard(BuildContext context) {
  final bloc = context.read<ProfileBloc>();
  showDialog(context: context, builder: (_) => SettingBoard(bloc: bloc));
}
