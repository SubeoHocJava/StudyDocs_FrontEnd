import 'package:flutter/material.dart';
import '../widgets/mark_all_read_widget.dart';

class NotificationMarkAllReadDemo extends StatelessWidget {
  const NotificationMarkAllReadDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '❖ Đánh dấu thông báo',
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
             const Spacer(),
            MarkAllReadWidget(
              onTap: () {},
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
