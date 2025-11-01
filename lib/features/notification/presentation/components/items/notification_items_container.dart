import 'package:flutter/material.dart';
import 'package:studydocs/features/notification/data/model/notification.dart';

import 'notification_item.dart';

/// Container chứa và quản lý danh sách các notification
/// - Sử dụng ListView.builder để tối ưu hiệu năng với danh sách dài
/// - Quản lý trạng thái checkbox của các items (cho chế độ trash)
/// - Vô hiệu hóa scroll để tránh conflict với scroll chính
class NotificationItemsContainer extends StatefulWidget {
  final List<AppNotification> notifications;
  final Function(List<String>)? onCheckedIdsChanged;

  const NotificationItemsContainer({
    super.key,
    required this.notifications,
    this.onCheckedIdsChanged,
  });

  @override
  State<NotificationItemsContainer> createState() => _NotificationItemsContainerState();
}

class _NotificationItemsContainerState extends State<NotificationItemsContainer> {
  final List<String> _checkedIds = [];

  void _handleCheck(String id, bool isChecked) {
    setState(() {
      if (isChecked) {
        _checkedIds.add(id);
      } else {
        _checkedIds.remove(id);
      }
      widget.onCheckedIdsChanged?.call(_checkedIds);
    });
  }

  // Container quản lý danh sách notification và trạng thái checkbox.

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Set a height that will shrink to fit the content
      height: widget.notifications.length * 100.0, // Assuming each item is roughly 100 pixels high
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), // để không bị cuộn lồng nhau
        itemCount: widget.notifications.length,
        itemBuilder: (context, index) {
          final item = widget.notifications[index];
          return NotificationItem(
            notification: item,
            onCheck: _handleCheck,
          );
        },
      ),
    );
  }

}

