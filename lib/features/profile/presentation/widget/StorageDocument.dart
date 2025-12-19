import 'package:flutter/cupertino.dart';

import '../../../../core/widgets/document/ListDocument.dart';
import '../../../library/data/model/Document.dart';
import '../../logic/profile_state.dart';


class StorageDocument extends StatelessWidget{
  final ProfileLoaded state;
  const StorageDocument({super.key,  required this.state});

  @override
  Widget build(BuildContext context) {
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
        ListDocument(documents, crossAxisCount: 0)
      ],
    );
  }
}