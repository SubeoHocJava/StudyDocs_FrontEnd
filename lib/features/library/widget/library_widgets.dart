import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onSearch;

  const SearchInput({super.key, this.controller, this.onSearch});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;//screen size
    return Center(
      child: SizedBox(
        width: screenWidth * 0.8,//80% width
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
                  width: 20,
                  height: 20,
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
  const UploadFileButton({super.key, required this.onPressed,  this.file });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;//screen size
    return Container(
      margin: const EdgeInsets.all(16),
      child: Center(
        child: SizedBox(
          width: screenWidth *0.8,//80% width
          height: 200,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.headerBg,
              fixedSize: const Size(100, 100),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/icons/upload.png"),
                const SizedBox(height: 8),
                   Text(
                     file ?? "Đăng tải tài liệu bài giảng khóa học đề thi...",
                     textAlign: TextAlign.center,
                   )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

