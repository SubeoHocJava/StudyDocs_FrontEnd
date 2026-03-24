import 'package:flutter/material.dart';
import '../../domain/entity/notification_model.dart';

class NotificationDetailWidget extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailWidget({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF1A237E),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          // Large Icon
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF00BCD4),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chat_bubble, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Montserrat',
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: notification.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' ${notification.content}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(indent: 24, endIndent: 24),
          _buildActionButton(
            icon: Icons.email_outlined,
            label: 'Đánh dấu là đã đọc',
            onTap: () {},
          ),
          _buildActionButton(
            icon: Icons.delete_outline,
            label: 'Xóa thông báo này',
            onTap: () {},
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF1A237E),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
