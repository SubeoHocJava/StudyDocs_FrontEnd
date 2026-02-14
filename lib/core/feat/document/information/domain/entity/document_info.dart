import 'author.dart';

class DocumentInfo {
  final String id;
  final int startYear;
  final int endYear;
  final int pageNumber;
  final int likes;
  final int dislikes;
  final Author author;

  DocumentInfo({
    required this.id,
    required this.startYear,
    required this.endYear,
    required this.pageNumber,
    required this.author,
    required this.likes,
    required this.dislikes,
  });
}
