import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../../../../core/constants/app_icons.dart';

// Lưu cấu hình mỗi loại notification (mã type, màu nền avatar, đường dẫn icon).
// Thực tế: khi mở rộng, thêm entry vào map `types` để hỗ trợ loại mới.
class NotificationTypeStore {
  static NotificationType like = NotificationType(
    "LIKE",
    Color.fromRGBO(5, 5, 196, 1),
    AppAssets.like,
  );
  static NotificationType download = NotificationType(
    "DOWNLOAD",
    Color.fromRGBO(0, 126, 90, 1),
    AppAssets.download,
  );
  static final Map<String, NotificationType> types = {
    like.type: like,
    download.type: download,
  };

  // Lấy cấu hình từ chuỗi type (case-insensitive). Nếu không tìm thấy trả null.
  static NotificationType? fromType(String type) {
    return types[type.toUpperCase()];
  }
}

class NotificationType {
  final String type;
  final Color backgroundColor;
  final String src;

  NotificationType(this.type, this.backgroundColor, this.src);
}
