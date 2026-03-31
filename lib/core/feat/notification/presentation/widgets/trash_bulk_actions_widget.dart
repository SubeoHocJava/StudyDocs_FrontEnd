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
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Restore All Button
          Expanded(
            child: InkWell(
              onTap: onRestoreAll,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFE3F2FD), // Light blue
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.restore, color: Color(0xFF1976D2), size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Khôi phục tất cả',
                      style: TextStyle(
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Vertical Divider
          Container(width: 1, height: 48, color: Colors.blue[200]),
          // Delete All Button
          Expanded(
            child: InkWell(
              onTap: onDeleteAll,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEBEE), // Light red
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_forever, color: Color(0xFF1A237E), size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Xóa tất cả',
                      style: TextStyle(
                        color: Color(0xFF1A237E),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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
