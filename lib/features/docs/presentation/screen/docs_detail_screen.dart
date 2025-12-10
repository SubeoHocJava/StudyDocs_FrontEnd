import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/docs_bloc.dart';
import '../../logic/docs_state.dart';
import '../../domain/entity/document_entity.dart';
import '../widgets/doc_header.dart';
import '../widgets/doc_info_row.dart';
import '../widgets/doc_actions.dart';
import '../widgets/pdf_preview_thumbnail.dart';
import '../widgets/uploader_info.dart';
import '../widgets/like_dislike_row.dart';
import '../widgets/comments_section.dart';
import '../widgets/comment_input.dart';
import '../../../../core/constants/app_icons.dart';

class DocsDetailScreen extends StatefulWidget {
  const DocsDetailScreen({super.key});

  @override
  State<DocsDetailScreen> createState() => _DocsDetailScreenState();
}

class _DocsDetailScreenState extends State<DocsDetailScreen> {
  int _currentPage = 0;
  final int _commentsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DocsBloc, DocsState>(
          builder: (context, state) {
            if (state is! DocsLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            final doc = state.docDetails;

            return SingleChildScrollView(
              padding: EdgeInsets.all(size.width * 0.04),
              child: isWide
                  ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 11,
                    child: PdfPreviewThumbnail(
                      isFullSize: true,
                      pages: doc.pages,
                      fileSize: doc.fileSize,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 9,
                    child: _buildRightColumn(doc, state),
                  ),
                ],
              )
                  : _buildRightColumn(doc, state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRightColumn(DocumentEntity doc, DocsLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        DocHeader(title: doc.title),
        const SizedBox(height: 12),
        DocInfoRow(text: doc.course, iconPath: AppAssets.folder),
        const SizedBox(height: 6),
        DocInfoRow(text: doc.school, iconPath: AppAssets.school),
        const SizedBox(height: 6),
        Text(
          "${doc.pages} trang • ${doc.fileSize}",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        const SizedBox(height: 16),
        DocActions(state: state),
        const SizedBox(height: 20),
        Text("Năm học: ${doc.year}"),
        const SizedBox(height: 12),
        const Text("Đăng tải bởi:", style: TextStyle(fontWeight: FontWeight.w500)),
        UploaderInfo(doc: doc),
        const SizedBox(height: 12),
        LikeDislikeRow(doc: doc),
        const SizedBox(height: 20),
        if (MediaQuery.of(context).size.width <= 600)
          PdfPreviewThumbnail(
            isFullSize: true,
            pages: doc.pages,
            fileSize: doc.fileSize,
          ),
        const SizedBox(height: 20),
        CommentsSection(
          comments: doc.comments,
          currentPage: _currentPage,
          commentsPerPage: _commentsPerPage,
          onPageChange: (page) => setState(() => _currentPage = page),
        ),
        const SizedBox(height: 20),
        CommentInput(
          onSend: (text) {
            print("User commented: $text");
          },
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}