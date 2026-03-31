import 'package:flutter/material.dart';
import '../../../../constants/app_icons.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _buildButton(
                iconAsset: AppAssets.notiRestore,
                label: 'Khôi phục tất cả',
                backgroundColor: const Color(0xFFE3F2FD),
                textColor: const Color(0xFF1976D2),
                onTap: onRestoreAll,
              ),
            ),
            const VerticalDivider(width: 16, color: Colors.transparent),
            Expanded(
              child: _buildButton(
                iconAsset: AppAssets.notiTrash,
                label: 'Xóa tất cả',
                backgroundColor: const Color(0xFFFFEBEE),
                textColor: const Color(0xFFD32F2F),
                onTap: onDeleteAll,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String iconAsset,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconAsset, width: 24, height: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
