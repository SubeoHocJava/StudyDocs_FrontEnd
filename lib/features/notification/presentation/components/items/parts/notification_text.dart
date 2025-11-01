import 'package:flutter/material.dart';

/// Widget hiển thị nội dung chính của notification
/// - Giới hạn 2 dòng, thêm dấu ... nếu dài hơn
/// - Font size được tính toán theo layout helper để responsive
class NotificationText extends StatelessWidget {
  final String content;
  final double fontSize;

  const NotificationText({
    super.key,
    required this.content,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      // Dùng fontSize được tính bởi layout helper để nhất quán
      style: TextStyle(fontSize: fontSize),
    );
  }
}

