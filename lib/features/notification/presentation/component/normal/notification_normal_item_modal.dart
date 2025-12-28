import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/features/notification/domain/entity/notification_entity.dart';
import 'package:studydocs/features/notification/presentation/component/helpers/notification_modal_size_helper.dart';
import 'package:studydocs/features/notification/presentation/component/base/notification_modal_action.dart';

import '../base/notification_modal_layout.dart';

/// Modal hiển thị chi tiết một notification và các action có thể thực hiện
/// - Hiển thị nội dung đầy đủ của notification
/// - Các action: đánh dấu đã đọc, xóa thông báo
/// - Sử dụng NotificationModalLayout để căn chỉnh và responsive
class NotificationNormalItemModal extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback? onMarkAsRead;
  final VoidCallback onDelete;

  const NotificationNormalItemModal({
    super.key,
    required this.notification,
    this.onMarkAsRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final sizes = NotificationModalSizeHelper.calculate(context);

    return NotificationModalLayout(
      child: Column(
        children: [
          _NotificationModalContent(
            notification: notification,
            iconSize: sizes.clampedIconSize,
            fontSize: sizes.clampedFontSize,
          ),
          Column(
            children: [
              if (!notification.isRead && onMarkAsRead != null)
                NotificationModalAction(
                  label: "Đánh dấu đã đọc",
                  asset: AppAssets.markAsRead,
                  size: sizes.clampedButtonIconSize,
                  onPressed: () {
                    onMarkAsRead!.call();
                    Navigator.pop(context);
                  },
                ),
              NotificationModalAction(
                label: "Xóa thông báo này",
                asset: AppAssets.bin,
                size: sizes.clampedSmallButtonIconSize,
                onPressed: () {
                  onDelete();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget hiển thị nội dung chi tiết của notification trong modal
/// - Icon loại notification (lớn hơn trong list)
/// - Nội dung đầy đủ (không giới hạn số dòng)
/// - Divider phân cách với phần actions
/// Kích thước (icon, font) được điều chỉnh theo màn hình
class _NotificationModalContent extends StatelessWidget {
  final NotificationEntity notification;
  final double iconSize;
  final double fontSize;

  const _NotificationModalContent({
    required this.notification,
    required this.iconSize,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: NotificationTypeIcon(
              type: notification.type,
              size: iconSize,
            ),
          ),
        ),
        Text(
          notification.body,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSize),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Divider(height: 1),
        ),
      ],
    );
  }
}
