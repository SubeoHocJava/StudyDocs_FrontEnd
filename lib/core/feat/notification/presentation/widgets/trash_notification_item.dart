import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_icons.dart';
import '../../domain/entity/notification_model.dart';
import '../../utils/time_utils.dart';
import '../utils/notification_ui_mapper.dart';

class TrashNotificationItemWidget extends StatelessWidget {
  final NotificationModel notification;
  final bool isSelected;
  final bool isSelectionMode;
  final ValueChanged<bool?> onSelectChanged;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  const TrashNotificationItemWidget({
    Key? key,
    required this.notification,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onSelectChanged,
    required this.onRestore,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = NotificationUIMapper.getConfig(notification.type);

    return Slidable(
      key: Key(notification.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.5,
        children: [
          CustomSlidableAction(
            onPressed: (_) => onRestore(),
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.primary,
            child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Image.asset(AppAssets.notiRestore ?? AppAssets.markAsRead, width: 24, height: 24, color: AppColors.primary),
                 const SizedBox(height: 4),
                 Text('Khôi phục', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
               ]
            ),
          ),
          Container(
            width: 1,
            height: 48,
            color: AppColors.border,
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
          CustomSlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.danger,
            child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                  Image.asset(AppAssets.notiTrash ?? AppAssets.bin, width: 24, height: 24, color: AppColors.danger),
                  const SizedBox(height: 4),
                  Text('Xóa', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
               ]
            ),
          ),
        ],
      ),
      child: InkWell(
        onLongPress: () {
          if (!isSelectionMode) onSelectChanged(true);
        },
        onTap: () {
          if (isSelectionMode) onSelectChanged(!isSelected);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryLight : AppColors.white,
            border: Border(bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.5))),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                config['iconAsset'], 
                width: 36, 
                height: 36, 
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                         style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimaryLight,
                          fontFamily: 'Montserrat', 
                          height: 1.4,
                        ),
                        children: [
                           TextSpan(
                            text: notification.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                     const SizedBox(height: 4),
                     Row(
                       children: [
                         Text(
                          TimeUtils.formatTimeAgo(notification.receivedAt), 
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                         ),
                         const SizedBox(width: 8),
                         Container(
                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                           decoration: BoxDecoration(
                             color: Color(0xFFFFE0DB), 
                             borderRadius: BorderRadius.circular(4),
                           ),
                           child: Text(
                             'Đã xóa vào ${notification.deletedAt?.day ?? DateTime.now().day}/${notification.deletedAt?.month ?? DateTime.now().month}/${notification.deletedAt?.year ?? DateTime.now().year}',
                             style: TextStyle(fontSize: 10, color: AppColors.danger),
                           ),
                         )
                       ],
                     )
                  ],
                ),
              ),
              if (isSelectionMode)
                Checkbox(
                  value: isSelected,
                  onChanged: onSelectChanged,
                  activeColor: AppColors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
