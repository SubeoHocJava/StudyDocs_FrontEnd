import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studydocs/core/feat/notification/presentation/widgets/mark_all_read_widget.dart';

void main() {
  testWidgets('MarkAllReadWidget displays text and calls onTap', (WidgetTester tester) async {
    bool tapped = false;
    
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MarkAllReadWidget(
          onTap: () => tapped = true,
        ),
      ),
    ));

    expect(find.text('Đánh dấu tất cả là đã đọc'), findsOneWidget);
    expect(find.byIcon(Icons.done_all), findsOneWidget);

    await tester.tap(find.byType(MarkAllReadWidget));
    expect(tapped, isTrue);
  });
}
