import 'package:equatable/equatable.dart';
import 'package:studydocs/features/docs/data/model/document_model.dart';

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
  final String? fileId;
  final bool isLiked;

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
    this.fileId,
    this.isLiked = false,
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
    isLiked,
  ];

  // Convert Model → Entity
  static DocumentEntity fromModel(DocumentModel model) {
    return DocumentEntity(
      id: model.id ?? '', // Handle nullable ID from model
      title: model.title,
      description: model.description,
      author: model.uploader, // Map uploader -> author
      authorId: null, // Model doesn't seem to have authorId
      thumbnailUrl: model.previewUrls.isNotEmpty ? model.previewUrls.first : null,
      category: model.course, // Map course -> category
      institution: model.school, // Map school -> institution
      pageCount: model.pages,
      academicYear: model.year,
      viewCount: 0, // Model lacks viewCount
      downloadCount: 0,
      likesCount: model.likes,
      commentsCount: model.commentsCount ?? model.comments.length,
      rating: 0.0,
      createdAt: null, // Model uses String year, not DateTime
      updatedAt: null,
      fileUrl: model.downloadUrl,
      fileType: null,
      fileId: model.fileId,
      isLiked: model.currentUserReaction == 'LIKE',
    );
  }

  DocumentEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? author,
    String? authorId,
    String? thumbnailUrl,
    String? category,
    String? institution,
    int? pageCount,
    String? academicYear,
    int? viewCount,
    int? downloadCount,
    int? likesCount,
    int? commentsCount,
    double? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? fileUrl,
    String? fileType,
    String? fileId,
    bool? isLiked,
  }) {
    return DocumentEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
      authorId: authorId ?? this.authorId,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
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
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
