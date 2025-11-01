import 'package:flutter/material.dart';

class NotificationSectionHeader extends StatelessWidget {
  final String time;

  const NotificationSectionHeader({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = (screenWidth * 0.04).clamp(12.0, 24.0);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        time,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
      ),
    );
  }
}

