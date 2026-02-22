import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary, // or dynamic color based on type if needed
            ),
            child: Image.asset(
              config['iconAsset'], 
              width: 48, height: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(fontSize: 14, color: AppColors.textPrimaryLight, height: 1.5, fontFamily: 'Roboto'),
              children: [
                TextSpan(text: "${notification.title}", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " "),
                TextSpan(text: notification.content),
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
                  Icon(Icons.mark_email_read, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text('Đánh dấu là đã đọc', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimaryLight)),
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
                  Icon(Icons.delete, color: AppColors.danger),
                  const SizedBox(width: 8),
                  Text('Xóa thông báo này', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimaryLight)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
