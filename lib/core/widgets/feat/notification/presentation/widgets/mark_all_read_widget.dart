import 'package:flutter/material.dart';

import '../../../../../constants/app_icons.dart';
import 'package:studydocs/core/constants/app_colors.dart';

class MarkAllReadWidget extends StatelessWidget {
  final VoidCallback onTap;

  const MarkAllReadWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.notiMarkAsRead,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 12),
            const Text(
              'Đánh dấu tất cả là đã đọc',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.customColor7, // Dark navy
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
