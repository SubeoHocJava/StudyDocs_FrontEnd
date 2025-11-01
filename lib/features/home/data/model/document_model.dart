import '../../domain/entity/document_entity.dart';

class DocumentModel extends DocumentEntity {
  const DocumentModel({
    required super.id,
    required super.title,
    super.description,
    super.author,
    super.authorId,
    super.thumbnailUrl,
    super.category,
    super.institution,
    super.pageCount,
    super.academicYear,
    super.viewCount,
    super.downloadCount,
    super.likesCount,
    super.commentsCount,
    super.rating,
    super.createdAt,
    super.updatedAt,
    super.fileUrl,
    super.fileType,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      author: json['author']?.toString(),
      authorId: json['authorId']?.toString(),
      thumbnailUrl: json['thumbnailUrl']?.toString(),
      category: json['category']?.toString(),
      institution: json['institution']?.toString(),
      pageCount: json['pageCount'] as int?,
      academicYear: json['academicYear']?.toString(),
      viewCount: json['viewCount'] as int?,
      downloadCount: json['downloadCount'] as int?,
      likesCount: json['likesCount'] as int?,
      commentsCount: json['commentsCount'] as int?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : null,
      fileUrl: json['fileUrl']?.toString(),
      fileType: json['fileType']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'author': author,
      'authorId': authorId,
      'thumbnailUrl': thumbnailUrl,
      'category': category,
      'institution': institution,
      'pageCount': pageCount,
      'academicYear': academicYear,
      'viewCount': viewCount,
      'downloadCount': downloadCount,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'rating': rating,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'fileUrl': fileUrl,
      'fileType': fileType,
    };
  }

  DocumentEntity toEntity() {
    return DocumentEntity(
      id: id,
      title: title,
      description: description,
      author: author,
      authorId: authorId,
      thumbnailUrl: thumbnailUrl,
      category: category,
      institution: institution,
      pageCount: pageCount,
      academicYear: academicYear,
      viewCount: viewCount,
      downloadCount: downloadCount,
      likesCount: likesCount,
      commentsCount: commentsCount,
      rating: rating,
      createdAt: createdAt,
      updatedAt: updatedAt,
      fileUrl: fileUrl,
      fileType: fileType,
    );
  }
}

