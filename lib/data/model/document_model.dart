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
  final String? category;
  final String? institution;
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
    return DocumentModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      author: json['author']?.toString(),
      authorId: json['author_id']?.toString(),
      thumbnailUrl: json['thumbnail_url']?.toString(),
      category: json['category']?.toString(),
      institution: json['institution']?.toString(),
      pageCount: json['page_count'] as int?,
      academicYear: json['academic_year']?.toString(),
      viewCount: json['view_count'] as int?,
      downloadCount: json['download_count'] as int?,
      likesCount: json['likes_count'] as int?,
      commentsCount: json['comments_count'] as int?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      fileUrl: json['file_url']?.toString(),
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