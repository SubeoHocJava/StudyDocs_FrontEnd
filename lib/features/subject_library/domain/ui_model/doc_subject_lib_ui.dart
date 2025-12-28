import 'package:studydocs/core/widgets/document/model/list_document_ui.dart';

import '../../../../core/widgets/document/model/row_document_ui.dart';

class DocumentSubjectLibUI implements RowDocumentItem, DocumentUiList {
  @override
  final String id;
  @override
  final String title;
  @override
  final String category;
  @override
  final String institution;
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

  const DocumentSubjectLibUI({
    required this.id,
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
}
