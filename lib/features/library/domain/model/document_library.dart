import 'package:studydocs/core/widgets/document/model/list_document_ui.dart';

import '../../../../core/widgets/document/model/row_document_ui.dart';

class DocumentLibraryUI extends DocumentUiList implements RowDocumentItem {
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


  const DocumentLibraryUI({
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
