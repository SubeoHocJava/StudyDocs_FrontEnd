// lib/features/docs/presentation/screen/docs_detail_screen.dart

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

/// Màn hình chi tiết tài liệu (full thông tin + preview PDF + comments)
class DocsDetailScreen extends StatefulWidget {
  const DocsDetailScreen({super.key});
  @override State<DocsDetailScreen> createState() => _DocsDetailScreenState();
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
            /// Loading → spinner
            if (state is! DocsLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            final doc = state.docDetails;

            /// Layout responsive:
            /// - Wide screen: PDF bên trái + thông tin bên phải
            /// - Mobile: chỉ hiển thị thông tin, PDF nằm dưới
            return SingleChildScrollView(
              padding: EdgeInsets.all(size.width * 0.04),
              child: isWide
                  ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 11,
                    child: PdfPreviewThumbnail(isFullSize: true),
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

  /// Cột toàn bộ nội dung (dùng chung cho mobile + wide)
  Widget _buildRightColumn(DocumentEntity doc, DocsLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header điều hướng + tiêu đề
        DocHeader(
          title: doc.title,
          isDetail: true,
          onTapArrow: () => Navigator.pop(context),
        ),

        const SizedBox(height: 12),

        /// Môn học – trường học
        DocInfoRow(text: doc.course, iconPath: AppAssets.folder),
        const SizedBox(height: 6),
        DocInfoRow(text: doc.school, iconPath: AppAssets.school),

        const SizedBox(height: 16),

        /// Nút Save + Share + Report
        DocActions(state: state),

        const SizedBox(height: 20),

        /// Năm học
        Text("Năm học: ${doc.year}"),

        const SizedBox(height: 12),

        /// Người đăng tải
        const Text("Đăng tải bởi:", style: TextStyle(fontWeight: FontWeight.w500)),
        UploaderInfo(doc: doc),

        const SizedBox(height: 12),

        /// Like – Dislike
        LikeDislikeRow(doc: doc),

        const SizedBox(height: 20),

        /// Mobile hiển thị PDF bên dưới
        if (MediaQuery.of(context).size.width <= 600) ...[
          PdfPreviewThumbnail(isFullSize: true),
          const SizedBox(height: 20),
        ],

        /// Comment list + pagination
        CommentsSection(
          comments: doc.comments,
          currentPage: _currentPage,
          commentsPerPage: _commentsPerPage,
          onPageChange: (page) => setState(() => _currentPage = page),
        ),

        const SizedBox(height: 20),

        /// Input comment
        CommentInput(onSend: () {}),

        const SizedBox(height: 40),
      ],
    );
  }
}
