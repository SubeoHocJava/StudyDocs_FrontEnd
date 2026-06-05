class DocumentSummaryModel {
  final String id;
  final String title;
  final String? thumbnail;
  final String category;
  final String school;
  final int pageCount;
  final String year;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final bool isBookmarked;

  const DocumentSummaryModel({
    required this.id,
    required this.title,
    this.thumbnail,
    required this.category,
    required this.school,
    required this.pageCount,
    required this.year,
    required this.likeCount,
    required this.commentCount,
    this.isLiked = false,
    this.isBookmarked = false,
  });

  DocumentSummaryModel copyWith({
    String? id,
    String? title,
    String? thumbnail,
    String? category,
    String? school,
    int? pageCount,
    String? year,
    int? likeCount,
    int? commentCount,
    bool? isLiked,
    bool? isBookmarked,
  }) {
    return DocumentSummaryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      thumbnail: thumbnail ?? this.thumbnail,
      category: category ?? this.category,
      school: school ?? this.school,
      pageCount: pageCount ?? this.pageCount,
      year: year ?? this.year,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  factory DocumentSummaryModel.fromJson(Map<String, dynamic> json) {
    return DocumentSummaryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      thumbnail: json['thumbnail'] as String?,
      category: json['category'] as String,
      school: json['school'] as String,
      pageCount: json['pageCount'] as int,
      year: json['year'] as String,
      likeCount: json['likeCount'] as int,
      commentCount: json['commentCount'] as int,
      isLiked: json['isLiked'] as bool? ?? false,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'category': category,
      'school': school,
      'pageCount': pageCount,
      'year': year,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
    };
  }
}
