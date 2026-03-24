import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studydocs/core/feat/notification/presentation/widgets/trash_notification_item.dart';
import 'package:studydocs/core/feat/notification/domain/entity/notification_model.dart';

void main() {
  testWidgets('TrashNotificationItemWidget displays info and actions', (WidgetTester tester) async {
    final notification = NotificationModel(
      id: '1',
      title: 'Trash Item',
      content: 'Deleted content',
      type: NotificationType.like,
      receivedAt: DateTime.now(),
      deletedAt: DateTime.now(),
      isRead: true,
      avatarUrl: '',
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TrashNotificationItemWidget(
          notification: notification,
          isSelected: false,
          onToggleSelection: (_) {},
          onRestore: () {},
          onDelete: () {},
        ),
      ),
    ));

    expect(find.text('Trash Item'), findsOneWidget);
    expect(find.text('Khôi phục'), findsOneWidget);
    expect(find.text('Xóa'), findsOneWidget);
    expect(find.textContaining('Đã xóa vào'), findsOneWidget);
  });
}
