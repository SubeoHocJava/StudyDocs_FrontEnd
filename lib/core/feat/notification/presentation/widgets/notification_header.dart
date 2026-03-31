import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';

class NotificationHeader extends StatelessWidget {
  final String title;
  final VoidCallback onMoreTap;

  const NotificationHeader({
    super.key,
    required this.title,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A9E), // Blueish color from image
              fontFamily: 'Montserrat',
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Color(0xFF1A1A9E), size: 30),
            onPressed: onMoreTap,
          ),
        ],
      ),
    );
  }
}
