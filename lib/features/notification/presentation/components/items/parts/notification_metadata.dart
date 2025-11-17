import 'dart:async';

import 'package:flutter/material.dart';
import 'package:studydocs/data/model/notification.dart';

/// Widget hiển thị thông tin phụ của notification:
/// - Thời gian tạo (tự động cập nhật mỗi phút)
/// - Nếu là notification đã xóa: hiển thị thêm badge "Đã xóa ngày..."
/// Sử dụng Timer để tự động refresh thời gian hiển thị
class NotificationMetadata extends StatefulWidget {
  final AppNotification notification;

  const NotificationMetadata({
    super.key,
    required this.notification,
  });

  @override
  State<NotificationMetadata> createState() => _NotificationMetadataState();
}

class _NotificationMetadataState extends State<NotificationMetadata> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final timeFontSize = (screenWidth * 0.03).clamp(10.0, 16.0);
    final marginDelete = (screenWidth * 0.02).clamp(6.0, 16.0);

    return Row(
      children: [
        Text(
          widget.notification.formattedCreatedTime(),
          style: TextStyle(color: Colors.black, fontSize: timeFontSize),
        ),
        if (widget.notification.deletedAt != null)
          Container(
            margin: EdgeInsets.only(left: marginDelete),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(50, 225, 112, 85),
            ),
            child: Text(
              "Đã xóa ngày ${widget.notification.formatDeletedTime()}",
              style: TextStyle(color: Colors.red, fontSize: timeFontSize),
            ),
          ),
      ],
    );
  }
}

