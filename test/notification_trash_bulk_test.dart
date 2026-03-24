import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studydocs/core/feat/notification/presentation/widgets/trash_bulk_actions_widget.dart';

void main() {
  testWidgets('TrashBulkActionsWidget displays buttons and calls callbacks', (WidgetTester tester) async {
    bool restoreClicked = false;
    bool deleteClicked = false;
    
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TrashBulkActionsWidget(
          onRestoreAll: () => restoreClicked = true,
          onDeleteAll: () => deleteClicked = true,
        ),
      ),
    ));

    expect(find.text('Khôi phục tất cả'), findsOneWidget);
    expect(find.text('Xóa tất cả'), findsOneWidget);

    await tester.tap(find.text('Khôi phục tất cả'));
    expect(restoreClicked, isTrue);

    await tester.tap(find.text('Xóa tất cả'));
    expect(deleteClicked, isTrue);
  });
}
