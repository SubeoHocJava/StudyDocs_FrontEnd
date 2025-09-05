import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import '../../../model/Document.dart';

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
        Container(
          height: 175,
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // 👈 cuộn ngang
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              return MonoDocument(document: document);
            },
          ),
        ),
      ],
    );
  }
}

class MonoDocument extends StatelessWidget {
  final Document document;

  const MonoDocument({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          margin: EdgeInsets.all(12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.headerBg),
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
