import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/features/widget_shared/document/RowDocument.dart';
import '../../../model/Document.dart';
import '../../../widget_shared/document/ListDocument.dart';

class RecentlyUpload extends StatelessWidget {

  final List<Document>documents;
   RecentlyUpload(this.documents);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Tải lên gần đây",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        RowDocument(documents)
      ],
    );
  }
}
