import 'package:flutter/material.dart';
import '../widgets/notification_header.dart';

class NotificationHeaderDemo extends StatelessWidget {
  const NotificationHeaderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // The isolated feature
            NotificationHeader(
              title: 'Thông báo',
              onMoreTap: () {
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('More options tapped')),
                );
              },
            ),
            const Divider(),
            const Expanded(
              child: Center(
                child: Text('Đây là demo cho tính năng Header Thông báo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
