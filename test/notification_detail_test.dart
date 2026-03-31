import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studydocs/core/feat/notification/presentation/widgets/notification_detail_widget.dart';
import 'package:studydocs/core/feat/notification/domain/entity/notification_model.dart';

void main() {
  testWidgets('NotificationDetailWidget displays full content', (WidgetTester tester) async {
    final notification = NotificationModel(
      id: '1',
      title: 'Detail Title',
      content: 'Detailed content here...',
      type: NotificationType.system,
      receivedAt: DateTime.now(),
      isRead: true,
      avatarUrl: '',
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: NotificationDetailWidget(
          notification: notification,
        ),
      ),
    ));

    expect(find.text('Detail Title'), findsOneWidget);
    expect(find.text('Detailed content here...'), findsOneWidget);
  });
}
