import 'package:flutter/material.dart';
import 'package:studydocs/features/widget_shared/document/ListDocument.dart';

import '../../../model/Document.dart';

class StoredDocument extends StatelessWidget {
  final List<Document>documents;
 const StoredDocument(this.documents);



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Danh sách tài liệu",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
     ListDocument(documents)
      ],
    );
  }
}



