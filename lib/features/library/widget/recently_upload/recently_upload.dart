import 'package:flutter/material.dart';

import '../../../model/Document.dart';

class RecentlyUpload extends StatelessWidget {
  final List<Document> documents = [
    Document(
      title: "Tài liệu Flutter",
      subject: "Lập trình di động",
      school: "ĐH Công nghệ",
      pages: 120,
      date: "2025-08-01",
      likes: 45,
      comments: 10,
    ),
    Document(
      title: "Tài liệu Java",
      subject: "Lập trình hướng đối tượng",
      school: "ĐH Bách Khoa",
      pages: 200,
      date: "2025-08-10",
      likes: 60,
      comments: 15,
    ),
    Document(
      title: "Tài liệu Kotlin",
      subject: "Lập trình Android",
      school: "ĐH Khoa Học Tự Nhiên",
      pages: 150,
      date: "2025-08-20",
      likes: 35,
      comments: 8,
    ),
  ];

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
          height: 300,
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
          width: 200,
          margin: EdgeInsets.all(12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blueAccent),
          ),
          child: Image.asset(
            "assets/icons/search-icon.png",
            width: 150,
            height: 200,
          ),
        ),
        Text(document.title),
      ],
    );
  }
}
