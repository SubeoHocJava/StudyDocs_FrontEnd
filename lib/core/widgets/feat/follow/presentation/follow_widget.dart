import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import '../logic/follow_bloc.dart';
import '../logic/follow_state.dart';

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
            padding: EdgeInsets.all(responsive.size.width * 0.04), // responsive.defaultPadding
            alignment: Alignment.center,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Followers
                    _buildFollowButton(
                      context: context,
                      label: "${state.followData.numFollowMe} Người theo dõi",
                      color: AppColors.secondaryTeal,
                      index: 0,

                    ),
                    const SizedBox(width: 12),

                    // Following
                    _buildFollowButton(
                      context: context,
                      label: "${state.followData.numMeFollow} Đang theo dõi",
                      color: AppColors.secondaryBlue,
                      index: 1,

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

  Widget _buildFollowButton({
    required BuildContext context,
    required String label,
    required Color color,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}