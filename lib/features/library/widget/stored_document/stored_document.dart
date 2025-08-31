import 'package:flutter/material.dart';

import '../../../model/Document.dart';

class StoredDocument extends StatelessWidget {
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
            "Danh sách tài liệu",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true, // 👈 quan trọng
          physics: NeverScrollableScrollPhysics(), // 👈 tránh scroll riêng
          itemCount: documents.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 16.0,
              ),
              child: MonoDocument(
                document: documents[index],
              ), // 👉 dùng widget MonoSubject
            );
          },
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
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/icons/upload.png",
            width: 40,
            height: 40,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  document.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),

                // subject
                Row(
                  children: [
                    Icon(Icons.folder, size: 16, color: Colors.blue),
                    SizedBox(width: 4),
                    Text(document.subject),
                  ],
                ),
                SizedBox(height: 4),

                // school
                Row(
                  children: [
                    Image.asset("assets/icons/school.png", width: 16, height: 16),
                    SizedBox(width: 4),
                    Text(document.school),
                  ],
                ),
                SizedBox(height: 4),

                // page and date
                Row(
                  children: [
                    Icon(Icons.file_open_rounded, size: 16),
                    SizedBox(width: 4),
                    Text("${document.pages} trang"), // ✅ int -> String
                    SizedBox(width: 12),
                    Icon(Icons.calendar_today, size: 16),
                    SizedBox(width: 4),
                    Text(document.date),
                  ],
                ),
                SizedBox(height: 4),

                // like and comment
                Row(
                  children: [
                    Icon(Icons.favorite, size: 16, color: Colors.red),
                    SizedBox(width: 4),
                    Text("${document.likes}"), // ✅ int -> String
                    SizedBox(width: 12),
                    Icon(Icons.comment, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text("${document.comments}"), // ✅ int -> String
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

