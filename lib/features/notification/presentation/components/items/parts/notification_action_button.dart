import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/features/notification/data/model/notification.dart';
import 'package:studydocs/features/notification/presentation/components/modal/notification_item_modal.dart';

/// Widget hiển thị nút tương tác cho mỗi notification:
/// - Nếu notification chưa bị xóa: hiển thị nút "..." để mở modal actions
/// - Nếu đã bị xóa (trong trash): hiển thị checkbox để chọn nhiều mục
class NotificationActionButton extends StatelessWidget {
  final AppNotification notification;
  final bool isChecked;
  final void Function(bool) onCheckChanged;

  const NotificationActionButton({
    super.key,
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

