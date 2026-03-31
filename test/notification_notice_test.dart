import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studydocs/core/feat/notification/presentation/widgets/notification_item.dart';
import 'package:studydocs/core/feat/notification/domain/entity/notification_model.dart';

void main() {
  testWidgets('NotificationItemWidget displays notification info', (WidgetTester tester) async {
    final notification = NotificationModel(
      id: '1',
      title: 'Test User',
      content: 'liked your document',
      type: NotificationType.like,
      receivedAt: DateTime.now(),
      isRead: false,
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

    expect(find.text('Test User'), findsOneWidget);
    expect(find.textContaining('liked your document'), findsOneWidget);
    // Should NOT find an avatar image with NetworkImage if we replaced it with icon
    expect(find.byType(CircleAvatar), findsNothing);
    expect(find.byType(Image), findsOneWidget); // The icon
  });
}
