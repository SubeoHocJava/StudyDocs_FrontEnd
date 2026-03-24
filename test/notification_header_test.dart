import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studydocs/core/feat/notification/presentation/widgets/notification_header_widget.dart';

void main() {
  testWidgets('NotificationHeaderWidget displays title and more button', (WidgetTester tester) async {
    bool moreClicked = false;
    
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: NotificationHeaderWidget(
          title: 'Test Title',
          onMoreTap: () => moreClicked = true,
        ),
      ),
    ));

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.byIcon(Icons.more_horiz), findsOneWidget);

    await tester.tap(find.byIcon(Icons.more_horiz));
    expect(moreClicked, isTrue);
  });
}
