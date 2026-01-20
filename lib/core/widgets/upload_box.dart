import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../constants/app_colors.dart';
import '../constants/app_icons.dart';
import 'package:studydocs/features/upload_file/presentation/screen/upload_file_screen.dart';
import 'app_icon_button.dart';

class UploadBox extends StatelessWidget {
  final VoidCallback? onTap;
  const UploadBox({super.key, this.onTap});

  void _navigateToUpload(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UploadFileScreen()),
    );
    if (onTap != null) onTap!();
  }

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.white
          : Colors.black26,
      borderType: BorderType.RRect,
      radius: const Radius.circular(16),
      dashPattern: const [8, 6],
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToUpload(context),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              AppIconButton(
                assetPath: AppAssets.upload,
                onPressed: null,
                size: 30,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.white
                    : AppColors.headerForeground,
              ),
              const SizedBox(height: 8),
              Text(
                'Đăng tải bài giảng, tài liệu, khoá học, đề thi, ...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
