import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_icons.dart';

class GlobalNotificationOptionsBottomSheet extends StatelessWidget {
  final VoidCallback onMarkAllAsRead;
  final VoidCallback onDeleteAll;
  final VoidCallback onViewTrash;

  const GlobalNotificationOptionsBottomSheet({
    Key? key,
    required this.onMarkAllAsRead,
    required this.onDeleteAll,
    required this.onViewTrash,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
          InkWell(
            onTap: () {
              Navigator.pop(context);
              onMarkAllAsRead();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Image.asset(AppAssets.notiMarkAsRead, width: 24, height: 24, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text('Đánh dấu tất cả là đã đọc', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              onDeleteAll();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.notiTrash, width: 24, height: 24, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text('Xóa tất cả thông báo', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              onViewTrash();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.bin, width: 24, height: 24, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text('Xem thùng rác', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
