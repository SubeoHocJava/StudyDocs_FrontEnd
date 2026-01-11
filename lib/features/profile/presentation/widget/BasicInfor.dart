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
  const BasicInfor({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    var image = "assets/icons/avt.png";
    var name = state.fullName;
    var school = state.school;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.widthPercent(5),
        vertical: responsive.heightPercent(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// ================= TOP RIGHT BUTTON (SETTINGS / FOLLOW) =================
          Align(
            alignment: Alignment.topRight,
            child: _buildActionButton(context, responsive),
          ),

          SizedBox(height: responsive.heightPercent(1)),

          /// ================= AVATAR =================
          Container(
            width: responsive.widthPercent(30),
            height: responsive.widthPercent(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image:
                  image.isNotEmpty
                      ? DecorationImage(
                        image: AssetImage(image),
                        fit: BoxFit.cover,
                      )
                      : null,
              color: Colors.grey.shade300,
            ),
            child:
                image.isEmpty
                    ? Icon(
                      Icons.person,
                      size: responsive.widthPercent(20),
                      color: Colors.grey.shade700,
                    )
                    : null,
          ),

          SizedBox(height: responsive.heightPercent(1.5)),

          /// ================= NAME =================
          Text(
            name.isNotEmpty ? name : "Tên chưa cập nhật",
            style: TextStyle(
              fontSize: responsive.fontSize(18),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          /// ================= SCHOOL =================
          Text(
            school.isNotEmpty ? school : "Chưa có trường học",
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: responsive.fontSize(15),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, dynamic responsive) {
    final authState = context.read<AuthStatusCubit>().state;
    String? currentUserId;
    if (authState is AuthAuthenticated) {
      currentUserId = authState.userId;
    }

    final isOwnProfile = state.id == currentUserId;

    if (isOwnProfile) {
      return TextButton.icon(
        onPressed: () => _showSettingBoard(context),
        icon: Icon(Icons.settings, size: responsive.fontSize(16)),
        label: Text(
          "Cài đặt",
          style: TextStyle(fontSize: responsive.fontSize(13)),
        ),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.widthPercent(2),
            vertical: responsive.heightPercent(1),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }

    final isFollowing = state.isFollowing;

    return TextButton.icon(
      onPressed: () {
        if (isFollowing) {
          context.read<ProfileBloc>().add(UnfollowUser(state.id));
        } else {
          context.read<ProfileBloc>().add(FollowUser(state.id));
        }
      },
      icon: Icon(
        isFollowing ? Icons.person_remove : Icons.person_add,
        size: responsive.fontSize(16),
        color: isFollowing ? Colors.grey : Colors.blue,
      ),
      label: Text(
        isFollowing ? "Bỏ theo dõi" : "Theo dõi",
        style: TextStyle(
          fontSize: responsive.fontSize(13),
          color: isFollowing ? Colors.grey : Colors.blue,
        ),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.widthPercent(2),
          vertical: responsive.heightPercent(1),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isFollowing ? Colors.grey : Colors.blue,
          ),
        ),
      ),
    );
  }
}

void _showSettingBoard(BuildContext context) {
  final bloc = context.read<ProfileBloc>();
  showDialog(context: context, builder: (context) => SettingBoard(bloc: bloc));
}
