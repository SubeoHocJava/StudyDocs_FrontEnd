import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/core/constants/app_colors.dart';

import '../logic/follow_bloc.dart';
import '../logic/follow_state.dart';
import 'package:studydocs/screens/profile/logic/profile_bloc.dart';
import 'package:studydocs/screens/profile/logic/profile_state.dart';
import 'package:studydocs/screens/profile/logic/profile_event.dart';

class Follow extends StatelessWidget {
  const Follow({super.key});

  @override
  Widget build(BuildContext context) {
    // Giả sử bạn có Responsive ở đây
    final responsive = MediaQuery.of(context);

    return BlocBuilder<FollowBloc, FollowState>(
      builder: (context, state) {
        if (state is FollowInitialState || state is FollowLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FollowLoadedState) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(responsive.size.width * 0.04),
            // responsive.defaultPadding
            alignment: Alignment.center,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Followers
                    GestureDetector(
                      onTap: () {
                        final profileState = context.read<ProfileBloc>().state;
                        if (profileState is ProfileLoadedState) {
                          final uid = profileState.user.id ?? "me";
                          context.push('/followers/$uid').then((_) {
                             context.read<ProfileBloc>().add(ProfileReloadSilent(uid));
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryTeal,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          border: Border.all(
                            color: AppColors.secondaryTeal.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          "${state.followData.numFollowMe} người theo dõi",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                    ),

                    // 🔹 Đường line dọc
                    SizedBox(
                      height: 40, // chỉnh tùy theo UI
                      child: VerticalDivider(
                        width: 20, // khoảng cách hai bên
                        thickness: 1.2, // độ dày line
                        color: Colors.grey,
                      ),
                    ),

                    // Following
                    GestureDetector(
                      onTap: () {
                        final profileState = context.read<ProfileBloc>().state;
                        if (profileState is ProfileLoadedState) {
                          final uid = profileState.user.id ?? "me";
                          context.push('/following/$uid').then((_) {
                             context.read<ProfileBloc>().add(ProfileReloadSilent(uid));
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryBlue,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          border: Border.all(
                            color: AppColors.secondaryBlue.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          "${state.followData.numMeFollow} Đang theo dõi",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        if (state is FollowErrorState) {
          return Center(child: Text("Error: ${state.message}"));
        }

        return const SizedBox();
      },
    );
  }
}
