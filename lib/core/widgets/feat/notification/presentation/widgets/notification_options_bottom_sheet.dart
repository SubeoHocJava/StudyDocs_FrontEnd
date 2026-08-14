import 'package:flutter/material.dart';
import 'package:studydocs/screens/notification/domain/entity/notification_model.dart';
import 'package:studydocs/core/constants/app_icons.dart';

class NotificationOptionsBottomSheet extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onMarkAsRead;
  final VoidCallback onDelete;

  const NotificationOptionsBottomSheet({
    super.key,
    required this.notification,
    required this.onMarkAsRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          _buildOption(
            icon: AppAssets.notiMarkAsRead,
            title: 'Đánh dấu là đã đọc',
            onTap: () {
              Navigator.pop(context);
              onMarkAsRead();
            },
          ),
          _buildOption(
            icon: AppAssets.notiTrash,
            title: 'Xóa thông báo này',
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Image.asset(icon, width: 24, height: 24),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
