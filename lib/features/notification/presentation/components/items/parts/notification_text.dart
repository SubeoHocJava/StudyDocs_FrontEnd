import 'package:flutter/material.dart';

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
      style: TextStyle(fontSize: fontSize),
    );
  }
}

