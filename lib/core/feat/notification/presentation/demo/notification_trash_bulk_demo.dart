import 'package:flutter/material.dart';
import '../widgets/trash_bulk_actions_widget.dart';

class NotificationTrashBulkDemo extends StatelessWidget {
  const NotificationTrashBulkDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Demo: Trash Bulk Actions'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Tính năng: Thao tác hàng loạt trong thùng rác',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TrashBulkActionsWidget(
              onRestoreAll: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Restored all selected items')),
                );
              },
              onDeleteAll: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Deleted all selected items')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
