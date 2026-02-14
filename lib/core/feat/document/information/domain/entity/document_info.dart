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

  DocumentInfo copyWith({
    String? id,
    int? startYear,
    int? endYear,
    int? pageNumber,
    int? likes,
    int? dislikes,
    Author? author,
  }) {
    return DocumentInfo(
      id: id ?? this.id,
      startYear: startYear ?? this.startYear,
      endYear: endYear ?? this.endYear,
      pageNumber: pageNumber ?? this.pageNumber,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      author: author ?? this.author,
    );
  }
}
