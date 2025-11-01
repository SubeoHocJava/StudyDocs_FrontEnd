import 'package:flutter/cupertino.dart';


import '../../../../core/widgets/document/RowDocument.dart';
import '../../../library/data/model/Document.dart';


class UploadDocument extends StatelessWidget {
  final List<Document> docs;
  const UploadDocument(this.docs);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            "Tài liệu bạn tải lên",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        RowDocument(docs)
      ],
    );
  }
}
