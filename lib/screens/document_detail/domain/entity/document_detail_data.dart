import 'package:equatable/equatable.dart';

class DocumentDetailData extends Equatable {
  final String id;
  final String title;
  final String description;
  final String fileUrl;
  final int fileSize;
  final String fileType;
  final String? thumbnail;
  final String categoryName;
  final String schoolName;
  final int pageCount;
  final String year;
  final int likeCount;
  final int commentCount;
  final int downloadCount;
  final int viewCount;
  final bool isLiked;
  final bool isBookmarked;
  final bool isPublic;
  final DateTime createdAt;
  
  // Author info
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final String authorSchoolName;

  // Mock fields for missing data in API
  final int dislikeCount;
  final bool isDisliked;

  const DocumentDetailData({
    required this.id,
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.fileSize,
    required this.fileType,
    this.thumbnail,
    required this.categoryName,
    required this.schoolName,
    required this.pageCount,
    required this.year,
    required this.likeCount,
    required this.commentCount,
    required this.downloadCount,
    required this.viewCount,
    required this.isLiked,
    required this.isBookmarked,
    required this.isPublic,
    required this.createdAt,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.authorSchoolName,
    required this.dislikeCount,
    required this.isDisliked,
  });

  @override
  List<Object?> get props => [
    id, title, description, fileUrl, fileSize, fileType, thumbnail, categoryName, schoolName, pageCount, year,
    likeCount, commentCount, downloadCount, viewCount, isLiked, isBookmarked, isPublic, createdAt,
    authorId, authorName, authorAvatar, authorSchoolName, dislikeCount, isDisliked
  ];
}
