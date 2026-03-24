import 'package:flutter/material.dart';
import '../widgets/mark_all_read_widget.dart';

class NotificationMarkAllReadDemo extends StatelessWidget {
  const NotificationMarkAllReadDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mark All Read Demo')),
      body: Column(
        children: [
          MarkAllReadWidget(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Marked all as read')),
              );
            },
          ),
        ],
      ),
    );
  }
}
