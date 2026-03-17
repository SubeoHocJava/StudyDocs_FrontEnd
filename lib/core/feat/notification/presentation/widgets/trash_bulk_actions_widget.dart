import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildButton(
              icon: Icons.restore_from_trash,
              label: 'Khôi phục tất cả',
              color: const Color(0xFFE3F2FD),
              textColor: const Color(0xFF1976D2),
              onTap: onRestoreAll,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildButton(
              icon: Icons.delete_sweep,
              label: 'Xóa tất cả',
              color: const Color(0xFFFFEBEE),
              textColor: const Color(0xFFD32F2F),
              onTap: onDeleteAll,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: textColor.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
