import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/docs_bloc.dart';
import '../../logic/docs_state.dart';
import '../../domain/entity/document_entity.dart';
import '../widgets/doc_header.dart';
import '../widgets/doc_info_row.dart';
import '../widgets/doc_actions.dart';
import '../widgets/like_dislike_row.dart';
import '../widgets/pdf_single_page_preview.dart'; // Preview trang đầu
import '../widgets/uploader_info.dart';
import 'docs_detail_screen.dart';
import '../../../../core/constants/app_icons.dart';

class DocsScreen extends StatelessWidget {
  const DocsScreen({super.key});

  void _openDetail(BuildContext context) {
    final docsBloc = context.read<DocsBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: docsBloc,
          child: const DocsDetailScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isWide = size.width > 600;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DocsBloc, DocsState>(
          builder: (context, state) {
            if (state is DocsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is DocsError) {
              return Center(child: Text(state.message));
            }
            if (state is! DocsLoaded) {
              return const SizedBox.shrink();
            }

            final doc = state.docDetails;

            return SingleChildScrollView(
              padding: EdgeInsets.all(size.width * 0.04),
              child: isWide
                  ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: _buildInfoColumn(context, doc, state),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 5,
                    child: PdfSinglePagePreview(
                      doc: doc,
                      isFullSize: false,
                    ),
                  ),
                ],
              )
                  : _buildInfoColumn(context, doc, state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoColumn(BuildContext context, DocumentEntity doc, DocsLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        // Mobile: Preview 1 trang
        if (MediaQuery.of(context).size.width <= 600)
          PdfSinglePagePreview(
            doc: doc,
            isFullSize: false,
          ),
        const SizedBox(height: 20),
        // Mobile: Nút "Xem thêm"
        if (MediaQuery.of(context).size.width <= 600)
          Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => _openDetail(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Xem thêm",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 22),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}