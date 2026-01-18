import 'package:studydocs/core/widgets/document/model/list_document_ui.dart';
import 'package:studydocs/core/widgets/document/model/row_document_ui.dart';

class DocumentProfile implements RowDocumentItem, DocumentUiList {
  @override
  final String id;
  @override
  final String? fileId;
  @override
  final String title;
  @override
  final String category;
  @override
  final String institution;
  @override
  int get pageCount => pages;
  final int pages;
  @override
  final String createdAt;
  @override
  final int likesCount;
  @override
  final int commentsCount;
  @override
  final String? thumbnailUrl;

  @override
  final bool isLiked;
  @override
  final bool isSaved;

  const DocumentProfile({
    required this.id,
    this.fileId,
    required this.title,
    required this.category,
    required this.institution,
    required this.pages,
    required this.createdAt,
    required this.likesCount,
    required this.commentsCount,
    this.thumbnailUrl,
    this.isLiked = false,
    this.isSaved = false,
  });

  @override
  String? get thumbnail => thumbnailUrl;

  @override
  List<Object?> get props => [
    id,
    fileId,
    title,
    category,
    institution,
    pages,
    createdAt,
    likesCount,
    commentsCount,
    thumbnailUrl,
    isLiked,
    isSaved,
  ];

  @override
  bool? get stringify => true;

  DocumentProfile copyWith({
    String? id,
    String? title,
    String? category,
    String? institution,
    int? pages,
    String? createdAt,
    int? likesCount,
    int? commentsCount,
    String? thumbnailUrl,
    bool? isLiked,
    bool? isSaved,
  }) {
    return DocumentProfile(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      institution: institution ?? this.institution,
      pages: pages ?? this.pages,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
