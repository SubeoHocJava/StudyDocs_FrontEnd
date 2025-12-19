import 'package:flutter/material.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';

import '../../logic/profile_state.dart';


class Statistical extends StatelessWidget {
  final ProfileLoaded state;
  const Statistical({super.key,  required this.state});
  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    const numFollowMe = 1;
    const numMeFollow = 1;

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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
              Container(
                width: 2,
                height: dividerHeight,
                color: Colors.black,
              ),

              // RIGHT BLOCK
              Container(
                width: rightWidth,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
          const ActivityStatistics(),
        ],
      ),
    );
  }
}

class ActivityStatistics extends StatelessWidget {
  const ActivityStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Chưa có dữ liệu hoạt động",
      style: TextStyle(
        fontSize: context.responsive.fontSize(14),
        color: Colors.grey,
      ),
    );
  }
}
