import 'package:flutter/material.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'package:studydocs/core/widgets/document/model/list_document_ui.dart';
import 'package:studydocs/features/library/domain/model/document_library.dart';
import '../../../../core/widgets/document/ListDocument.dart';

class StoredDocument extends StatelessWidget {
  final List<DocumentLibraryUI> documents;
  final int? crossAxisCount;
  
  // Optional callbacks - widgets can provide their own implementations
  final void Function(DocumentUiList)? onDownload;
  final void Function(DocumentUiList)? onSave;
  final void Function(DocumentUiList)? onLike;
  final void Function(DocumentUiList)? onComment;
  final void Function(DocumentUiList)? onTap;

  const StoredDocument(
    this.documents, {
    this.crossAxisCount,
    this.onDownload,
    this.onSave,
    this.onLike,
    this.onComment,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    // Tính số cột responsive
    final columns = crossAxisCount ??
        responsive.getGridColumnCount(
          mobile: 2,
          tablet: 3,
          desktop: 5,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(responsive.isMobile ? 12 : 16),
          child: Text(
            "Danh sách tài liệu",
            style: TextStyle(
              fontSize: responsive.fontSize(18),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: responsive.heightPercent(1)),
        // ListDocument responsive - use provided callbacks
        ListDocument(
          documents.cast<DocumentUiList>(),
          onDownload: onDownload,
          onSave: onSave,
          onLike: onLike,
          onComment: onComment,
          onTap: onTap,
        ),
      ],
    );
  }
}
