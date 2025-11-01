import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/features/notification/models/notification.dart';
import 'package:studydocs/features/notification/presentation/components/modal/notification_item_modal.dart';

class NotificationActionButton extends StatelessWidget {
  final AppNotification notification;
  final bool isChecked;
  final void Function(bool) onCheckChanged;

  const NotificationActionButton({
    super.key,
    required this.notification,
    required this.onCheckChanged, required this.isChecked,
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
    if (notification.deletedAt == null) {
      return IconButton(
        onPressed: () => _showModal(context),
        icon: Image.asset(AppAssets.moreHoriz),
      );
    }

    return Checkbox(
      value: isChecked,
      onChanged: (value) => onCheckChanged(value ?? false),
    );
  }
}

