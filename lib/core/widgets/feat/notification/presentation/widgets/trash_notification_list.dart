import 'package:flutter/material.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_icons.dart';
import 'trash_bulk_actions_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:studydocs/screens/notification/domain/entity/notification_model.dart';
import 'trash_notification_item.dart';


class TrashNotificationList extends StatelessWidget {
  final List<NotificationModel> trashList;
  final List<String> selectedTrashIds;
  final bool isSelectionMode;
  final Function(String) onToggleSelection;
  final Function(String) onRestore;
  final Function(String) onDelete;
  final VoidCallback onRestoreAllSelected;
  final VoidCallback onDeleteAllSelected;
  final Function(String)? onEnterSelectionMode;

  const TrashNotificationList({
    super.key,
    required this.trashList,
    required this.selectedTrashIds,
    required this.isSelectionMode,
    required this.onToggleSelection,
    required this.onRestore,
    required this.onDelete,
    required this.onRestoreAllSelected,
    required this.onDeleteAllSelected,
    this.onEnterSelectionMode,
  });

  @override
  Widget build(BuildContext context) {
    if (trashList.isEmpty) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('Thùng rác trống', style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      );
    }

    return Column(
      children: [
        // Selection count header (Optional, based on image 3/5)
        if (isSelectionMode)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFFE3F2FD), // Light blue background from Image 2
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.primary, size: 22),
                const SizedBox(width: 10),
                Text(
                  'Đã chọn ${selectedTrashIds.length} mục',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ),
        
        Expanded(
          child: SlidableAutoCloseBehavior(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: trashList.length,
              itemBuilder: (ctx, idx) {
                final note = trashList[idx];
                return Slidable(
                  key: ValueKey(note.id),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    extentRatio: 0.5,
                    children: [
                      CustomSlidableAction(
                        onPressed: (_) => onRestore(note.id),
                        backgroundColor: const Color(0xFFE3F1FF), // Light blue
                        foregroundColor: const Color(0xFF1A237E), // Dark navy
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppAssets.notiRestore, 
                              width: 24, 
                              height: 24, 
                              color: const Color(0xFF1A237E),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Khôi phục', 
                              style: TextStyle(
                                fontSize: 10, 
                                color: Color(0xFF1A237E),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomSlidableAction(
                        onPressed: (_) => onDelete(note.id),
                        backgroundColor: const Color(0xFFFFDDE1), // Light pink/red
                        foregroundColor: const Color(0xFFD32F2F), // Dark red
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppAssets.bin, 
                              width: 24, 
                              height: 24, 
                              color: const Color(0xFFD32F2F),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Xóa', 
                              style: TextStyle(
                                fontSize: 10, 
                                color: Color(0xFFD32F2F),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  child: TrashNotificationItemWidget(
                    notification: note,
                    isSelected: selectedTrashIds.contains(note.id),
                    isSelectionMode: isSelectionMode,
                    onToggleSelection: (_) => onToggleSelection(note.id),
                    onRestore: () => onRestore(note.id),
                    onDelete: () => onDelete(note.id),
                    onLongPress: () => onEnterSelectionMode?.call(note.id),
                  ),
                );
              },
            ),
          ),
        ),
        
        // Bottom Action Bar
        TrashBulkActionsWidget(
          onRestoreAll: onRestoreAllSelected,
          onDeleteAll: onDeleteAllSelected,
        ),
      ],
    );
  }
}
