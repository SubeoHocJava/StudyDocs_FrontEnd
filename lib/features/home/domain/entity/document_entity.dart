import 'package:equatable/equatable.dart';

class DocumentEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String? author;
  final String? authorId;
  final String? thumbnailUrl;
  final String? category;
  final String? institution;
  final int? pageCount;
  final String? academicYear;
  final int? viewCount;
  final int? downloadCount;
  final int? likesCount;
  final int? commentsCount;
  final double rating;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? fileUrl;
  final String? fileType;

  const DocumentEntity({
    required this.id,
    required this.title,
    this.description,
    this.author,
    this.authorId,
    this.thumbnailUrl,
    this.category,
    this.institution,
    this.pageCount,
    this.academicYear,
    this.viewCount,
    this.downloadCount,
    this.likesCount,
    this.commentsCount,
    this.rating = 0.0,
    this.createdAt,
    this.updatedAt,
    this.fileUrl,
    this.fileType,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        author,
        authorId,
        thumbnailUrl,
        category,
        institution,
        pageCount,
        academicYear,
        viewCount,
        downloadCount,
        likesCount,
        commentsCount,
        rating,
        createdAt,
        updatedAt,
        fileUrl,
        fileType,
      ];
}

