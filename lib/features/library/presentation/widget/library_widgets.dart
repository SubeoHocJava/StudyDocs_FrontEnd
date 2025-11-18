import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onSearch;

  const SearchInput({super.key, this.controller, this.onSearch});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Center(
      child: SizedBox(
        width: responsive.widthPercent(responsive.isMobile ? 80 : 60),
        child: SearchBar(
          controller: controller,
          hintText: 'Tìm kiếm các khóa học bài giảng tài liệu',
          trailing: <Widget>[
            Tooltip(
              message: 'Search',
              child: IconButton(
                onPressed: onSearch,
                icon: Image.asset(
                  "assets/icons/search-icon.png",
                  width: responsive.fontSize(18),
                  height: responsive.fontSize(18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UploadFileButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? file;

  const UploadFileButton({
    super.key,
    required this.onPressed,
    this.file,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      margin: EdgeInsets.all(responsive.isMobile ? 12 : 16),
      child: Center(
        child: SizedBox(
          width: responsive.widthPercent(responsive.isMobile ? 80 : 40),
          // height: responsive.heightPercent(30),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.headerBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/upload.png",
                  width: responsive.fontSize(100),
                  height: responsive.fontSize(100),
                ),
                SizedBox(height: responsive.heightPercent(1)),
                Text(
                  file ?? "Đăng tải tài liệu bài giảng khóa học đề thi...",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: responsive.fontSize(14)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
