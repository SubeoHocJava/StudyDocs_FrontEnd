import 'package:flutter/material.dart';
import '../widgets/mark_all_read_widget.dart';

class NotificationMarkAllReadDemo extends StatelessWidget {
  const NotificationMarkAllReadDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Demo: Mark All Read'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Tính năng: Đánh dấu tất cả là đã đọc',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            MarkAllReadWidget(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Marked all as read')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
