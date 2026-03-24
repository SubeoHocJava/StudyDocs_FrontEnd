import 'package:flutter/material.dart';

class MarkAllReadWidget extends StatelessWidget {
  final VoidCallback onTap;

  const MarkAllReadWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
        ),
        child: const Row(
          children: [
            Icon(Icons.done_all, color: Colors.blue, size: 20),
            SizedBox(width: 12),
            Text(
              'Đánh dấu tất cả là đã đọc',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
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
