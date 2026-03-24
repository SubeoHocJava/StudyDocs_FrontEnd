import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studydocs/core/feat/notification/presentation/widgets/notification_item.dart';
import 'package:studydocs/core/feat/notification/domain/entity/notification_model.dart';

void main() {
  testWidgets('NotificationItemWidget displays read notification', (WidgetTester tester) async {
    final notification = NotificationModel(
      id: '1',
      title: 'Read notification',
      content: 'This is already read',
      type: NotificationType.comment,
      receivedAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      avatarUrl: '',
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: NotificationItemWidget(
          notification: notification,
          onNotificationTap: () {},
          onMoreTap: () {},
          onDeleteTap: () {},
        ),
      ),
    ));

    expect(find.text('Read notification'), findsOneWidget);
    // Background should be transparent (Colors.transparent) for read notifications
    final container = tester.widget<Container>(find.byType(Container).first);
    expect(container.color, anyOf(equals(Colors.transparent), isNull));
  });
}
