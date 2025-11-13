import 'package:equatable/equatable.dart';
import 'package:studydocs/data/model/document_model.dart';

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

  // Convert Model → Entity
  static DocumentEntity fromModel(DocumentModel model) {
    return DocumentEntity(
      id: model.id,
      title: model.title,
      description: model.description,
      author: model.author,
      authorId: model.authorId,
      thumbnailUrl: model.thumbnailUrl,
      category: model.category,
      institution: model.institution,
      pageCount: model.pageCount,
      academicYear: model.academicYear,
      viewCount: model.viewCount,
      downloadCount: model.downloadCount,
      likesCount: model.likesCount,
      commentsCount: model.commentsCount,
      rating: model.rating,
      createdAt: model.createdAt != null
          ? DateTime.tryParse(model.createdAt!)  // Convert String → DateTime
          : null,
      updatedAt: model.updatedAt != null
          ? DateTime.tryParse(model.updatedAt!)
          : null,
      fileUrl: model.fileUrl,
      fileType: model.fileType,
    );
  }
}

