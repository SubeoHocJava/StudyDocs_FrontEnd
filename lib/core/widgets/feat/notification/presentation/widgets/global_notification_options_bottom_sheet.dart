import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/core/constants/app_colors.dart';

class GlobalNotificationOptionsBottomSheet extends StatelessWidget {
  final VoidCallback onMarkAllAsRead;
  final VoidCallback onDeleteAll;
  final VoidCallback onViewTrash;

  const GlobalNotificationOptionsBottomSheet({
    super.key,
    required this.onMarkAllAsRead,
    required this.onDeleteAll,
    required this.onViewTrash,
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
              color: AppColors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          _buildOption(
            icon: AppAssets.notiMarkAsRead,
            title: 'Đánh dấu tất cả là đã đọc',
            onTap: () {
              Navigator.pop(context);
              onMarkAllAsRead();
            },
          ),
          _buildOption(
            icon: AppAssets.bin,
            title: 'Xóa tất cả thông báo',
            onTap: () {
              Navigator.pop(context);
              onDeleteAll();
            },
            isDestructive: true,
          ),
          _buildOption(
            icon: AppAssets.notiTrash,
            title: 'Xem thùng rác',
            onTap: () {
              Navigator.pop(context);
              onViewTrash();
            },
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
          color: isDestructive ? AppColors.red : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
