import 'package:flutter/material.dart';
import 'package:studydocs/features/notification/data/model/notification_type.dart';

/// Widget hiển thị avatar tròn với icon tương ứng loại notification
/// - Lấy màu nền và icon từ NotificationTypeStore theo type
/// - Nếu type không có trong store hoặc asset lỗi: hiện icon placeholder
/// - Tự động điều chỉnh kích thước icon trong để tránh overflow
class NotificationTypeIcon extends StatelessWidget {
  final String type;
  final double size;

  const NotificationTypeIcon({
    super.key,
    required this.type,
    required this.size,
  });

  Widget _buildIcon(String type, double size) {
    var notificationType = NotificationTypeStore.fromType(type);
    final innerSize = (size * 0.5).clamp(16.0, size);
  // Nếu không có cấu hình cho type, hiển thị icon mặc định (placeholder)
  if (notificationType == null) {
      return CircleAvatar(
        backgroundColor: Colors.red,
        radius: size / 2,
        child: Padding(
          padding: EdgeInsets.all(size * 0.12),
          child: Icon(Icons.info, color: Colors.white, size: innerSize),
        ),
      );
    }
  // CircleAvatar chứa ảnh/biểu tượng; dùng padding tỉ lệ phần trăm để
  // đảm bảo kích thước bên trong luôn phù hợp với avatar.
  return CircleAvatar(
      backgroundColor: notificationType.backgroundColor,
      radius: size / 2,
      child: Padding(
        padding: EdgeInsets.all(size * 0.12),
        child: Image.asset(
          notificationType.src,
          width: innerSize,
          height: innerSize,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.info,
            color: Colors.white,
            size: innerSize,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildIcon(type, size);
  }
}

