import 'package:flutter/material.dart';
import '../../domain/entity/notification_model.dart';
import 'trash_notification_item.dart';

class TrashNotificationList extends StatelessWidget {
  final List<NotificationModel> trashList;
  final List<String> selectedTrashIds;
  final Function(String) onToggleSelection;
  final Function(String) onRestore;
  final Function(String) onDelete;
  final VoidCallback onRestoreAllSelected;
  final VoidCallback onDeleteAllSelected;

  const TrashNotificationList({
    super.key,
    required this.trashList,
    required this.selectedTrashIds,
    required this.onToggleSelection,
    required this.onRestore,
    required this.onDelete,
    required this.onRestoreAllSelected,
    required this.onDeleteAllSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (trashList.isEmpty) {
      return const Center(child: Text('Thùng rác trống'));
    }

    return Column(
      children: [
        if (selectedTrashIds.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.blue[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Đã chọn ${selectedTrashIds.length} mục'),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: onRestoreAllSelected,
                      icon: const Icon(Icons.restore),
                      label: const Text('Khôi phục'),
                    ),
                    TextButton.icon(
                      onPressed: onDeleteAllSelected,
                      icon: const Icon(Icons.delete_forever, color: Colors.red),
                      label: const Text('Xóa', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: trashList.length,
            itemBuilder: (ctx, idx) {
              final note = trashList[idx];
              return TrashNotificationItemWidget(
                notification: note,
                isSelected: selectedTrashIds.contains(note.id),
                onToggleSelection: (_) => onToggleSelection(note.id),
                onRestore: () => onRestore(note.id),
                onDelete: () => onDelete(note.id),
              );
            },
          ),
        ),
      ],
    );
  }
}
