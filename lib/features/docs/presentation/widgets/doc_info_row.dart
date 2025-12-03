import 'package:flutter/material.dart';

// Row hiển thị icon + text (thông tin tài liệu: môn học, trường, năm...)
class DocInfoRow extends StatelessWidget {
  final String text;      // Nội dung hiển thị
  final String iconPath;  // Đường dẫn asset icon

  const DocInfoRow({super.key, required this.text, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon của dòng thông tin
        Image.asset(iconPath, width: 20, height: 20),

        const SizedBox(width: 6),

        // Text có Expanded để tránh overflow nếu quá dài
        Expanded(child: Text(text)),
      ],
    );
  }
}
