import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';

import '../../logic/profile_state.dart';

class Statistical extends StatelessWidget {
  final ProfileLoaded state;

  const Statistical({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    int numFollowMe = state.numFollowMe;
    int numMeFollow = state.numMeFollow;

    int numMyUpload=state.numMyUpload;
    int numMyLikes=state.numMyLikes;
    int numMyComment=state.numMyComment;

    // responsive width theo thiết bị
    final leftWidth = responsive.responsiveValue(
      mobile: responsive.widthPercent(30),
      tablet: responsive.widthPercent(25),
      desktop: responsive.widthPercent(20),
    );

    final rightWidth = responsive.responsiveValue(
      mobile: responsive.widthPercent(40),
      tablet: responsive.widthPercent(35),
      desktop: responsive.widthPercent(22),
    );

    final dividerHeight = responsive.responsiveValue(
      mobile: 50.0,
      tablet: 60.0,
      desktop: 70.0,
    );

    return Container(
      width: double.infinity,
      padding: responsive.defaultPadding,
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LEFT BLOCK
              Container(
                width: leftWidth,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "$numFollowMe người theo dõi",
                  style: TextStyle(
                    fontSize: responsive.fontSize(14),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // DIVIDER
              Container(width: 2, height: dividerHeight, color: Colors.black),

              // RIGHT BLOCK
              Container(
                width: rightWidth,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Đang theo dõi $numMeFollow người",
                  style: TextStyle(
                    fontSize: responsive.fontSize(14),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          ActivityStatistics(numMyUpload: numMyUpload, numMyLikes: numMyLikes, numMyComment: numMyComment,),
        ],
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
