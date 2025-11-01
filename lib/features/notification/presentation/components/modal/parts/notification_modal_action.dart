import 'package:flutter/material.dart';

import 'helpers/notification_modal_size_helper.dart';

class NotificationModalAction extends StatelessWidget {
  final String label;
  final String asset;
  final double size;
  final VoidCallback onPressed;

  const NotificationModalAction({
    super.key,
    required this.label,
    required this.asset,
    required this.size,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sizes = NotificationModalSizeHelper.calculate(screenWidth);
    
    return TextButton.icon(
      onPressed: onPressed,
      icon: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Image.asset(
          asset,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: sizes.clampedTextSize,
          color: const Color.fromARGB(255, 0, 15, 76),
        ),
      ),
    );
  }
}

