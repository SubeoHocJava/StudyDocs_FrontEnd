import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';

class MoreDetail extends StatelessWidget {
  const MoreDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Center(
      child: Container(
        width: responsive.widthPercent(responsive.isMobile ? 80 : 160),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tên tài liệu
            Text(
              "Tên tài liệu",
              style: TextStyle(
                fontSize: responsive.fontSize(18),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: responsive.heightPercent(1)),
            TextField(
              decoration: InputDecoration(
                hintText: "Nhập tên ngắn gọn và đúng nội dung",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: responsive.heightPercent(2)),

            // Năm học
            Text(
              "Năm học",
              style: TextStyle(
                fontSize: responsive.fontSize(18),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: responsive.heightPercent(1)),
            TextField(
              decoration: InputDecoration(
                hintText: "Chọn năm học",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: responsive.heightPercent(2)),

            // Mô tả
            Text(
              "Mô tả",
              style: TextStyle(
                fontSize: responsive.fontSize(18),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: responsive.heightPercent(1)),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Mô tả ngắn gọn về tài liệu nhưng đầy đủ thông tin cần thiết",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: responsive.heightPercent(2)),

            // Button
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: Size(
                    responsive.widthPercent(30),
                    responsive.heightPercent(15),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.widthPercent(5),
                    vertical: responsive.heightPercent(1),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Xác nhận",
                  style: TextStyle(
                    fontSize: responsive.fontSize(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
