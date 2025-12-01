import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/features/notification/domain/model/notification_entity.dart';

import 'parts/helpers/notification_layout_helper.dart';
import 'parts/helpers/notification_press_state_mixin.dart';
import 'parts/notification_action_button.dart';
import 'parts/notification_metadata.dart';
import 'parts/notification_text.dart';
import 'parts/notification_type_icon.dart';

/// Widget hiển thị một thông báo trong danh sách
/// - Responsive theo chiều rộng màn hình (padding, icon, font)
/// - Hiệu ứng press state khi tương tác
/// - Hiển thị background khác biệt cho thông báo chưa đọc
/// - Tự động layout: icon - nội dung - action button
class NotificationItem extends StatefulWidget {
  final NotificationEntity notification;
  final void Function(String id, bool isChecked) onCheck;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onCheck,
  });

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem>
    with NotificationPressStateMixin {
  bool isChecked = false;

  Color? _getBackgroundColor(bool isPressed, bool isRead) {
    if (isPressed) return AppColors.notificationUnread.withValues(alpha: 0.7);
    if (!isRead) return AppColors.notificationUnread;
    return null;
  }

  // Widget chính cho 1 item notification.
  // - Dùng LayoutBuilder để lấy maxWidth và tính kích thước qua helper.
  // - AnimatedContainer để hiển thị hiệu ứng khi nhấn.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => handlePressDown(),
      onTapUp: (_) => handlePressUp(),
      onTapCancel: handlePressCancel,
      child: Builder(
        builder: (context) {
          final layout = NotificationLayoutHelper.calculate(context);
          final backgroundColor = _getBackgroundColor(isPressed, widget.notification.isRead);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
              horizontal: layout.horizontalPadding,
              vertical: layout.verticalPadding,
            ),
            color: backgroundColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NotificationTypeIcon(
                  type: widget.notification.type,
                  size: layout.iconSize,
                ),
                SizedBox(width: layout.spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      NotificationText(
                        content: widget.notification.content,
                        fontSize: layout.fontSize,
                      ),
                      NotificationMetadata(
                        notification: widget.notification,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: layout.spacing),
                NotificationActionButton(
                  notification: widget.notification,
                  isChecked: isChecked,
                  onCheckChanged: (value) {
                    setState(() {
                      isChecked = value;
                      widget.onCheck(widget.notification.id, value);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
