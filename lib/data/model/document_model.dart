import 'package:equatable/equatable.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:studydocs/features/home/domain/entity/document_entity.dart';
import '../../core/utils/helpers/document_url_helper.dart';

class DocumentModel extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String? author;
  final String? authorId;
  final String? thumbnailUrl;

  // API có thể trả về ID hoặc tên trực tiếp
  final String? universityId; // ID từ API để fetch tên sau
  final String? subjectId; // ID từ API để fetch tên sau
  final String? category; // Fallback nếu API trả tên trực tiếp
  final String? institution; // Fallback nếu API trả tên trực tiếp

  final int? pageCount;
  final String? academicYear;
  final int? viewCount;
  final int? downloadCount;
  final int? likesCount;
  final int? commentsCount;
  final double rating;
  final String? createdAt;
  final String? updatedAt;
  final String? fileUrl;
  final String? fileType;
  final String? fileId; // Added fileId

  const DocumentModel({
    required this.id,
    required this.title,
    this.description,
    this.author,
    this.authorId,
    this.thumbnailUrl,
    this.universityId,
    this.subjectId,
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
    this.fileId,
  });

  DocumentModel copyWith({
    String? id,
    String? title,
    String? description,
    String? author,
    String? authorId,
    String? thumbnailUrl,
    String? universityId,
    String? subjectId,
    String? category,
    String? institution,
    int? pageCount,
    String? academicYear,
    int? viewCount,
    int? downloadCount,
    int? likesCount,
    int? commentsCount,
    double? rating,
    String? createdAt,
    String? updatedAt,
    String? fileUrl,
    String? fileType,
    String? fileId,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
      authorId: authorId ?? this.authorId,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      universityId: universityId ?? this.universityId,
      subjectId: subjectId ?? this.subjectId,
      category: category ?? this.category,
      institution: institution ?? this.institution,
      pageCount: pageCount ?? this.pageCount,
      academicYear: academicYear ?? this.academicYear,
      viewCount: viewCount ?? this.viewCount,
      downloadCount: downloadCount ?? this.downloadCount,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fileUrl: fileUrl ?? this.fileUrl,
      fileType: fileType ?? this.fileType,
      fileId: fileId ?? this.fileId,
    );
  }

  // Parse JSON từ API
  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    // Check for 'fileId' or 'id'
    final extractedFileId = json['fileId']?.toString();

    // Sử dụng Helper để lấy thumbnail handle
    final thumbUrl = DocumentUrlHelper.getThumbnailUrl(
      previewDataView: json['previewDataView'],
      fallbackThumbnailUrl: json['thumbnail_url']?.toString(),
      fileId: extractedFileId,
    );

    return DocumentModel(
      id: json['id']?.toString() ?? '',
      fileId: extractedFileId,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      author: json['author']?.toString(),
      authorId: json['userId']?.toString() ?? json['author_id']?.toString(),
      thumbnailUrl: thumbUrl,
      universityId: json['universityId']?.toString(), // Parse ID từ API
      subjectId: json['subjectId']?.toString(), // Parse ID từ API
      category: json['category']?.toString(),
      institution: json['institution']?.toString(),
      pageCount: (json['totalPages'] ?? json['page_count']) as int?,
      academicYear:
          json['schoolYear']?.toString() ?? json['academic_year']?.toString(),
      viewCount: json['view_count'] as int?,
      downloadCount: json['download_count'] as int?,
      likesCount: json['likes_count'] as int?,
      commentsCount: json['comments_count'] as int?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      createdAt:
          json['createdAt']?.toString() ?? json['created_at']?.toString(),
      updatedAt:
          json['updatedAt']?.toString() ?? json['updated_at']?.toString(),
      fileUrl: json['downloadUrl']?.toString() ?? json['file_url']?.toString(),
      fileType: json['file_type']?.toString(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    author,
    authorId,
    thumbnailUrl,
    universityId,
    subjectId,
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
