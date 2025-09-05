import 'package:flutter/material.dart';

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
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: documents.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 16.0,
              ),
              child: MonoDocument(
                document: documents[index],
              ),
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
        // color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/icons/temp_image.jpg",
            width: 100,
            height: 125,
          ),
          SizedBox(width: 25),
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

