import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';

import '../../logic/profile_state.dart';

import '../../../../features/follow/presentation/screen/follow_screen.dart';

class Statistical extends StatelessWidget {
  final ProfileLoaded state;

  const Statistical({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      width: double.infinity,
      padding: responsive.defaultPadding,
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LEFT BLOCK: Followers
              _buildFollowButton(
                context: context,
                label: "${state.numFollowMe} Người theo dõi",
                color: AppColors.secondaryTeal,
                index: 0,
                responsive: responsive,
              ),
              const SizedBox(width: 12),
              // RIGHT BLOCK: Following
              _buildFollowButton(
                context: context,
                label: "${state.numMeFollow} Đang theo dõi",
                color: AppColors.secondaryTeal,
                index: 1,
                responsive: responsive,
              ),
            ],
          ),
          const SizedBox(height: 20),
          ActivityStatistics(
            numMyUpload: state.numMyUpload,
            numMyLikes: state.numMyLikes,
            numMyComment: state.numMyComment,
          ),
        ],
      ),
    );
  }

  Widget _buildFollowButton({
    required BuildContext context,
    required String label,
    required Color color,
    required int index,
    required ResponsiveHelper responsive,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FollowScreen(initialTab: index)),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: responsive.fontSize(14),
            fontWeight: FontWeight.bold,
            color: AppColors.headerForeground,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ActivityStatistics extends StatelessWidget {
  final int numMyUpload;
  final int numMyLikes;
  final int numMyComment;
  const ActivityStatistics({super.key, required this.numMyUpload, required this.numMyLikes, required this.numMyComment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey, // màu border
          width: 1, // độ dày
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Thống kê hoạt động",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                     numMyUpload.toString(),
                      style: TextStyle(
                        fontSize: 25,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Đăng tải"),
                  ],
                ),

                const VerticalDivider(color: Colors.grey, thickness: 1),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                     numMyLikes.toString(),
                      style: TextStyle(
                        fontSize: 25,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Lượt thích"),
                  ],
                ),

                const VerticalDivider(color: Colors.grey, thickness: 1),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      numMyComment.toString(),
                      style: TextStyle(
                        fontSize: 25,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Bình luận"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
