import 'package:flutter/material.dart';
import 'package:studydocs/features/notification/models/notification.dart';

import 'notification_item.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: widget.notifications
          .map(
            (item) => NotificationItem(
              notification: item,
              onCheck: _handleCheck,
            ),
          )
          .toList(),
    );
  }
}

