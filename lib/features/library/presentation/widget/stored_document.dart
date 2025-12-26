import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/utils/responsive_helper.dart';
import 'package:studydocs/core/widgets/document/model/list_document_ui.dart';
import 'package:studydocs/features/library/domain/model/document_library.dart';
import '../../../../core/widgets/document/ListDocument.dart';
import '../../logic/LibraryEvent.dart';
import '../../logic/library_bloc.dart';

class StoredDocument extends StatelessWidget {
  final List<DocumentLibraryUI> documents;
  final int? crossAxisCount;

  const StoredDocument(this.documents, {this.crossAxisCount, super.key});

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
        // ListDocument responsive
        ListDocument(
          documents.cast<DocumentUiList>(),
          onDownload: (doc) {
            context.read<LibraryBloc>().add(DownloadDocumentRequested(doc.id));
          },
          onSave: (doc) {
            context.read<LibraryBloc>().add(SaveDocumentRequested(doc.id));
          },
          onLike: (doc) {
            context.read<LibraryBloc>().add(LikeDocumentRequested(doc.id));
          },
          onComment: (doc) {
            context.read<LibraryBloc>().add(OpenCommentRequested(doc.id));
          },
        ),
      ],
    );
  }
}
