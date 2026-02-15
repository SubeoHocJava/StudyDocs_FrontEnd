import 'author.dart';

class DocumentInfo {
  final String id;
  final int startYear;
  final int endYear;
  final int pageNumber;
  final int likeCount;
  final int dislikeCount;
  final bool isLiked;
  final bool isDisliked;
  final Author author;

  DocumentInfo({
    required this.id,
    required this.startYear,
    required this.endYear,
    required this.pageNumber,
    required this.author,
    required this.likeCount,
    required this.dislikeCount,
    required this.isLiked,
    required this.isDisliked,
  });

  DocumentInfo copyWith({
    String? id,
    int? startYear,
    int? endYear,
    int? pageNumber,
    int? likeCount,
    int? dislikeCount,
    Author? author,
    bool? isLiked,
    bool? isDisliked,
  }) {
    return DocumentInfo(
      id: id ?? this.id,
      startYear: startYear ?? this.startYear,
      endYear: endYear ?? this.endYear,
      pageNumber: pageNumber ?? this.pageNumber,
      likeCount: likeCount ?? this.likeCount,
      dislikeCount: dislikeCount ?? this.dislikeCount,
      author: author ?? this.author,
      isLiked: isLiked ?? this.isLiked,
      isDisliked: isDisliked ?? this.isDisliked,
    );
  }
}
