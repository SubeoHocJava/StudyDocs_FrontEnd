import 'package:flutter/material.dart';
import '../widgets/trash_bulk_actions_widget.dart';

class NotificationTrashBulkDemo extends StatelessWidget {
  const NotificationTrashBulkDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '❖ Chọn nhiều thông báo thùng rác',
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const Spacer(),
            TrashBulkActionsWidget(
              onRestoreAll: () {},
              onDeleteAll: () {},
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
