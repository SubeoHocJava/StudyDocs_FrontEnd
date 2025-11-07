import 'package:flutter/material.dart';

import '../../../features/library/data/model/Document.dart';


class RowDocument extends StatelessWidget {
  final List<Document> documents;

  RowDocument(this.documents);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final document = documents[index];
          return MonoDocumentInRow(document: document);
        },
      ),
    );
  }
}

class MonoDocumentInRow extends StatelessWidget {
  final Document document;

  const MonoDocumentInRow({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; //screen size
    return Column(
      children: [
        Container(
          width: 100,
          margin: EdgeInsets.only(left: 12, bottom: 5, top: 5, right: 12),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black87),
          ),
          child: Image.asset(
            "assets/icons/search-icon.png",
            width: 75,
            height: 90,
          ),
        ),
        Text(document.title),
      ],
    );
  }
}
