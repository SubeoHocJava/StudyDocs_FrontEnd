import 'package:flutter/cupertino.dart';

import '../../model/Document.dart';
import '../../widget_shared/document/RowDocument.dart';

class MostLikeDocs extends StatelessWidget{
  final List<Document>documents;
  const MostLikeDocs(this.documents);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            "Lượt thích cao nhất",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        RowDocument(documents)
      ],
    );
  }
}