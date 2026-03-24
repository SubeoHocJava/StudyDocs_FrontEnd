import 'package:flutter/material.dart';

class NotificationHeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback onMoreTap;

  const NotificationHeaderWidget({
    super.key,
    this.title = 'Thông báo',
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: onMoreTap,
          ),
        ],
      ),
    );
  }
}
