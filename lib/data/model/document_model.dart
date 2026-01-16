import 'package:equatable/equatable.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:studydocs/features/home/domain/entity/document_entity.dart';

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
  });

  // Parse JSON từ API
  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    // Xử lý thumbnail từ previewDataView nếu có
    String? thumbUrl;
    if (json['previewDataView'] != null && json['previewDataView'] is Map) {
      final preview = json['previewDataView'];
      if (preview['baseUrl'] != null) {
        // Thay thế placeholder bằng trang 1 để làm thumbnail
        String url = preview['baseUrl'].toString().replaceAll(
          'PAGE_NUMBER_PLACEHOLDER',
          '1',
        );
        // Force JPG format for Cloudinary to ensure Flutter can decode it
        // Nếu URL chưa có đuôi ảnh, thêm .jpg
        if (!url.toLowerCase().endsWith('.jpg') &&
            !url.toLowerCase().endsWith('.png') &&
            !url.toLowerCase().endsWith('.jpeg')) {
          thumbUrl = "$url.jpg";
        } else {
          thumbUrl = url;
        }
      }
    } else {
      thumbUrl = json['thumbnail_url']?.toString();
    }

    return DocumentModel(
      id: json['id']?.toString() ?? '',
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
