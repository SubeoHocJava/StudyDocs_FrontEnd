import 'package:flutter/material.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';

class SchoolLabel extends StatelessWidget {
  const SchoolLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Center(
      child: Container(
        width: responsive.widthPercent(responsive.isMobile ? 80 : 160),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.school, size: responsive.fontSize(20)),
                SizedBox(width: responsive.widthPercent(2)),
                Expanded(
                  child: Text(
                    "Trường học",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: responsive.fontSize(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Chỉnh sửa",
                    style: TextStyle(
                      fontSize: responsive.fontSize(14),
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.heightPercent(1)),
            Row(
              children: [
                Text(
                  "Trường đại học nông lâm",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: responsive.fontSize(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
