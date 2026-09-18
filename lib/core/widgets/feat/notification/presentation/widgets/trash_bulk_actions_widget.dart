import 'package:flutter/material.dart';

import '../../../../../constants/app_icons.dart';
import 'package:studydocs/core/constants/app_colors.dart';


class TrashBulkActionsWidget extends StatelessWidget {
  final VoidCallback onRestoreAll;
  final VoidCallback onDeleteAll;

  const TrashBulkActionsWidget({
    super.key,
    required this.onRestoreAll,
    required this.onDeleteAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Restore All Button
          Expanded(
            child: InkWell(
              onTap: onRestoreAll,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.customColor15, // Very light blue
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.customColor11.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppAssets.notiRestore, width: 20, height: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Khôi phục tất cả',
                      style: TextStyle(
                        color: AppColors.customColor7, // Dark navy
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Delete All Button
          Expanded(
            child: InkWell(
              onTap: onDeleteAll,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.customColor2, // Pink/Light red
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppAssets.bin, width: 20, height: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Xóa tất cả',
                      style: TextStyle(
                        color: AppColors.customColor10, // Red
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
