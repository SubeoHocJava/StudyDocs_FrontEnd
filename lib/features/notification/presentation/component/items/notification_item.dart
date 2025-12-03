import 'dart:async';

import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/features/notification/domain/entity/notification_entity.dart';

import '../helpers/notification_layout_helper.dart';
import '../helpers/notification_press_state_mixin.dart';
import '../modal/notification_item_modal.dart';
import '../shared/notification_shared.dart';

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
                      _NotificationText(
                        content: widget.notification.body,
                        fontSize: layout.fontSize,
                      ),
                      _NotificationMetadata(
                        notification: widget.notification,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: layout.spacing),
                _NotificationActionButton(
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

/// Widget hiển thị nội dung chính của notification
/// - Giới hạn 2 dòng, thêm dấu ... nếu dài hơn
/// - Font size được tính toán theo layout helper để responsive
class _NotificationText extends StatelessWidget {
  final String content;
  final double fontSize;

  const _NotificationText({
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

/// Widget hiển thị thông tin phụ của notification:
/// - Thời gian tạo (tự động cập nhật mỗi phút)
/// - Nếu là notification đã xóa: hiển thị thêm badge "Đã xóa ngày..."
/// Sử dụng Timer để tự động refresh thời gian hiển thị
class _NotificationMetadata extends StatefulWidget {
  final NotificationEntity notification;

  const _NotificationMetadata({
    required this.notification,
  });

  @override
  State<_NotificationMetadata> createState() => _NotificationMetadataState();
}

class _NotificationMetadataState extends State<_NotificationMetadata> {
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

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: marginDelete,
      runSpacing: 4.0, // Add some vertical spacing for wrapped items
      children: [
        Text(
          widget.notification.formattedCreatedTime(),
          style: TextStyle(color: Colors.black, fontSize: timeFontSize),
        ),
        if (widget.notification.deletedAt != null)
          Container(
            // margin: EdgeInsets.only(left: marginDelete), // Removed, handled by spacing
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

/// Widget hiển thị nút tương tác cho mỗi notification:
/// - Nếu notification chưa bị xóa: hiển thị nút "..." để mở modal actions
/// - Nếu đã bị xóa (trong trash): hiển thị checkbox để chọn nhiều mục
class _NotificationActionButton extends StatelessWidget {
  final NotificationEntity notification;
  final bool isChecked;
  final void Function(bool) onCheckChanged;

  const _NotificationActionButton({
    required this.notification,
    required this.onCheckChanged,
    required this.isChecked,
  });

  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => NotificationItemModal(notification: notification),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Nếu thông báo chưa bị xóa: hiển thị nút mở modal action
    if (notification.deletedAt == null) {
      return IconButton(
        onPressed: () => _showModal(context),
        icon: Image.asset(AppAssets.moreHoriz),
      );
    }

    // Nếu trong trang 'trash' (deletedAt != null): cho phép chọn nhiều mục
    return Checkbox(
      value: isChecked,
      onChanged: (value) => onCheckChanged(value ?? false),
    );
  }
}
