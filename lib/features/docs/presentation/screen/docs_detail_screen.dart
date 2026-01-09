import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../logic/docs_bloc.dart';
import '../../logic/docs_event.dart';
import '../../logic/docs_state.dart';
import '../../domain/entity/document_entity.dart';
import '../widgets/doc_header.dart';
import '../widgets/doc_info_row.dart';
import '../widgets/doc_actions.dart';
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
  int _pdfPageIndex = 0;        // ← Biến riêng cho PDF preview
  int _commentPageIndex = 0;    // ← Biến riêng cho phân trang comment
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
                    child: _buildPdfViewer(doc.previewUrls, doc.pages),
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

  Widget _buildPdfViewer(List<String> previewUrls, int totalPages) {
    if (previewUrls.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: Text("Không có trang xem trước")),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: PageView.builder(
        itemCount: previewUrls.length,
        onPageChanged: (index) {
          setState(() {
            _pdfPageIndex = index;  // Chỉ cập nhật PDF page
          });
        },
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: previewUrls[index],
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.error, size: 60, color: Colors.red),
                ),
              ),
            ),
          );
        },
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
        const Text(
          "Đăng tải bởi:",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        UploaderInfo(doc: doc),
        const SizedBox(height: 12),
        LikeDislikeRow(doc: doc),
        const SizedBox(height: 20),

        // Mobile: Hiển thị PDF viewer nếu màn hình nhỏ
        if (MediaQuery.of(context).size.width <= 600)
          _buildPdfViewer(doc.previewUrls, doc.pages),
        if (MediaQuery.of(context).size.width <= 600) const SizedBox(height: 20),

        // Phần bình luận với biến riêng (không xung đột với PDF page)
        CommentsSection(
          comments: doc.comments,
          currentPage: _commentPageIndex,
          commentsPerPage: _commentsPerPage,
          onPageChange: (page) => setState(() => _commentPageIndex = page),
        ),
        const SizedBox(height: 20),

        CommentInput(
          onSend: (text) {
            context.read<DocsBloc>().add(PostComment(text));
          },
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}