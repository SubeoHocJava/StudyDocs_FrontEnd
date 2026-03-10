import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_icons.dart';
import '../../domain/entity/notification_model.dart';
import '../utils/notification_ui_mapper.dart';

class NotificationOptionsBottomSheet extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onMarkAsRead;
  final VoidCallback onDelete;

  const NotificationOptionsBottomSheet({
    Key? key,
    required this.notification,
    required this.onMarkAsRead,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = NotificationUIMapper.getConfig(notification.type);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Drag handle indicator
          Container(
            alignment: Alignment.center,
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gray.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Circular Notification Icon
          Image.asset(
            config['iconAsset'],
            width: 64,
            height: 64,
          ),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(fontSize: 16, color: AppColors.textPrimaryLight, height: 1.5, fontFamily: 'Montserrat'),
              children: [
                TextSpan(text: notification.title, style: TextStyle(fontWeight: FontWeight.w700)),
                if (notification.content.isNotEmpty)
                  TextSpan(text: " " + notification.content, style: TextStyle(fontWeight: FontWeight.normal)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(color: AppColors.border, thickness: 1),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              onMarkAsRead();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.notiMarkAsRead, width: 24, height: 24, color: AppColors.primary), // Custom Icon
                  const SizedBox(width: 12),
                  Text('Đánh dấu là đã đọc', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight)),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.notiTrash, width: 24, height: 24, color: AppColors.danger), // Custom Icon
                  const SizedBox(width: 12),
                  Text('Xóa thông báo này', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
