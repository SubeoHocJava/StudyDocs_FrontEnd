import 'package:flutter/material.dart';
import '../widgets/trash_bulk_actions_widget.dart';

class NotificationTrashBulkDemo extends StatelessWidget {
  const NotificationTrashBulkDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trash Bulk Actions Demo')),
      body: Column(
        children: [
          TrashBulkActionsWidget(
            onRestoreAll: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Restored all items')),
              );
            },
            onDeleteAll: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Deleted all items')),
              );
            },
          ),
        ],
      ),
    );
  }
}
