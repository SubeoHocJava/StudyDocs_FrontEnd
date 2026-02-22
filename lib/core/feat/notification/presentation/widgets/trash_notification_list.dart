import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
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
    Key? key,
    required this.trashList,
    required this.selectedTrashIds,
    required this.onToggleSelection,
    required this.onRestore,
    required this.onDelete,
    required this.onRestoreAllSelected,
    required this.onDeleteAllSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Thùng rác", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimaryLight)),
          ),
        ),
        Expanded(
          child: trashList.isEmpty 
          ? const Center(child: Text("Thùng rác trống"))
          : ListView.builder(
              itemCount: trashList.length,
              itemBuilder: (ctx, index) {
                final note = trashList[index];
                final isSelected = selectedTrashIds.contains(note.id);
                return TrashNotificationItemWidget(
                  notification: note, 
                  isSelected: isSelected,
                  onSelectChanged: (val) => onToggleSelection(note.id),
                  onRestore: () => onRestore(note.id),
                  onDelete: () => onDelete(note.id),
                );
              },
            ),
        ),
        if (selectedTrashIds.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: onRestoreAllSelected,
                  icon: const Icon(Icons.restore, color: AppColors.primary, size: 18),
                  label: const Text("Khôi phục tất cả", style: TextStyle(color: AppColors.primary)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surfaceLight,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: onDeleteAllSelected,
                  icon: const Icon(Icons.close, color: AppColors.danger, size: 18),
                  label: const Text("Xóa tất cả", style: TextStyle(color: AppColors.danger)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFE0DB),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }
}
