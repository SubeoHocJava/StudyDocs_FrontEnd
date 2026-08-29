import 'package:flutter/material.dart';

import '../../../../../constants/app_icons.dart';


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
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                  color: const Color(0xFFE3F1FF), // Very light blue
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF2196F3).withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppAssets.notiRestore, width: 20, height: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Khôi phục tất cả',
                      style: TextStyle(
                        color: Color(0xFF1A237E), // Dark navy
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
                  color: const Color(0xFFFFDDE1), // Pink/Light red
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
                        color: Color(0xFFD32F2F), // Red
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
