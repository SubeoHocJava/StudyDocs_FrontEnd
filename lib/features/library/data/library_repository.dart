

import 'model/Document.dart';

class LibraryRepository {
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
   List<Document> getDocdemo(){
    return documents;
  }
  final List<String> categories = [
    "Khoá học Flutter",
    "Khoá học Java",
    "Khoá học Kotlin",
  ];
  getCategorieDemo() {
    return categories;
  }
  // Tìm kiếm tài liệu
  searchDocument(String keyword) {
    final List<Document> res=[documents.first];
    return res;
  }
}