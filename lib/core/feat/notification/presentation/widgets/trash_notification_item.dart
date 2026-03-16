import 'package:flutter/material.dart';
import '../../domain/entity/notification_model.dart';
import '../utils/notification_ui_mapper.dart';

class TrashNotificationItemWidget extends StatelessWidget {
  final NotificationModel notification;
  final bool isSelected;
  final Function(bool?) onToggleSelection;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  const TrashNotificationItemWidget({
    super.key,
    required this.notification,
    required this.isSelected,
    required this.onToggleSelection,
    required this.onRestore,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final uiConfig = NotificationUIMapper.getConfig(notification.type);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: onToggleSelection,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            activeColor: Colors.blue,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(notification.avatarUrl),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(
                          notification.content,
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_backup_restore, size: 20),
                    onPressed: onRestore,
                    tooltip: 'Khôi phục',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_forever, size: 20, color: Colors.red),
                    onPressed: onDelete,
                    tooltip: 'Xóa vĩnh viễn',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
