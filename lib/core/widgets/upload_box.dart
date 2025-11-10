import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../constants/app_colors.dart';
import '../constants/app_icons.dart';
import 'app_icon_button.dart';

class UploadBox extends StatelessWidget {
  final VoidCallback? onTap;
  const UploadBox({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Colors.black26,
      borderType: BorderType.RRect,
      radius: const Radius.circular(16),
      dashPattern: const [8, 6],
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap ?? () {},
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: const [
              AppIconButton(
                assetPath: AppAssets.upload,
                onPressed: null, // hiển thị như một “icon” tĩnh
                size: 30,
                color: AppColors.headerFg,
              ),
              SizedBox(height: 8),
              Text(
                'Đăng tải bài giảng, tài liệu, khoá học, đề thi, ...',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
