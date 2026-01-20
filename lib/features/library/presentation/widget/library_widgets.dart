import 'package:dotted_border/dotted_border.dart';
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: SizedBox(
          width: responsive.widthPercent(responsive.isMobile ? 85 : 100),
          height: 50,
          child: SearchBar(
            controller: controller,
            backgroundColor: WidgetStateProperty.all(Theme.of(context).cardTheme.color),
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            shadowColor: WidgetStateProperty.all(Colors.transparent),
            side: WidgetStateProperty.all(
              BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            elevation: WidgetStateProperty.all(0),
            hintText: 'Tìm kiếm các khóa học, bài giảng, tài liệu',
            hintStyle: WidgetStateProperty.all(
              TextStyle(color: Colors.grey, fontSize: responsive.fontSize(14)),
            ),
            trailing: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.search, color: Theme.of(context).colorScheme.primary, size: 28),
              ),
            ],
            onTap: onSearch,
          ),
        ),
      ),
    );
  }
}

class UploadFileButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? file;

  const UploadFileButton({super.key, required this.onPressed, this.file});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: DottedBorder(
          color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5) ?? Colors.black26,
          strokeWidth: 1.5,
          dashPattern: const [6, 4],
          borderType: BorderType.RRect,
          radius: const Radius.circular(24),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: responsive.widthPercent(responsive.isMobile ? 85 : 40),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3)
                    : AppColors.primaryLight,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/upload.png",
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    file ?? "Đăng tải bài giảng, tài liệu,\nkhoá học, đề thi, . . .",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: responsive.fontSize(18),
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
