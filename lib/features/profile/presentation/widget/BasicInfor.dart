import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'package:studydocs/features/profile/logic/profile_bloc.dart';
import 'package:studydocs/features/profile/logic/profile_state.dart';
import '../../logic/profile_event.dart';

import 'SettingBoard.dart';
import '../../../../features/auth/presentation/bloc/auth_status_cubit.dart';

class BasicInfor extends StatelessWidget {
  final ProfileLoaded state;

  const BasicInfor({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    final image = "assets/icons/avt.png";
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
          _buildAvatar(responsive, image),

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
              color: Colors.blueAccent,
              fontSize: responsive.fontSize(15.0),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// ================= AVATAR WIDGET =================
  Widget _buildAvatar(ResponsiveHelper responsive, String image) {
    return Container(
      width: responsive.widthPercent(30.0),
      height: responsive.widthPercent(30.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: image.isNotEmpty
            ? DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        )
            : null,
        color: Colors.grey.shade300,
      ),
      child: image.isEmpty
          ? Icon(
        Icons.person,
        size: responsive.widthPercent(20.0),
        color: Colors.grey.shade700,
      )
          : null,
    );
  }

  /// ================= ACTION BUTTON =================
  Widget _buildActionButton(
      BuildContext context,
      ResponsiveHelper responsive,
      ) {
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
        icon: Icon(
          Icons.settings,
          size: responsive.fontSize(16.0),
        ),
        label: Text(
          "Cài đặt",
          style: TextStyle(
            fontSize: responsive.fontSize(13.0),
          ),
        ),
      );
    }

    /// ===== OTHER USER =====
    final isFollowing = state.isFollowing;

    return TextButton.icon(
      onPressed: () {
        context.read<ProfileBloc>().add(
          isFollowing
              ? UnfollowUser(state.id)
              : FollowUser(state.id),
        );
      },
      icon: Icon(
        isFollowing ? Icons.person_remove : Icons.person_add,
        size: responsive.fontSize(16.0),
        color: isFollowing ? Colors.grey : Colors.blue,
      ),
      label: Text(
        isFollowing ? "Bỏ theo dõi" : "Theo dõi",
        style: TextStyle(
          fontSize: responsive.fontSize(13.0),
          color: isFollowing ? Colors.grey : Colors.blue,
        ),
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(
            color: isFollowing ? Colors.grey : Colors.blue,
          ),
        ),
      ),
    );
  }
}

/// ================= SETTINGS DIALOG =================
void _showSettingBoard(BuildContext context) {
  final bloc = context.read<ProfileBloc>();
  showDialog(
    context: context,
    builder: (_) => SettingBoard(bloc: bloc),
  );
}
