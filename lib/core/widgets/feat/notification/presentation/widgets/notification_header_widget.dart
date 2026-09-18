import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';

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
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
              color: AppColors.black,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black54),
            onPressed: onMoreTap,
          ),
        ],
      ),
    );
  }
}
