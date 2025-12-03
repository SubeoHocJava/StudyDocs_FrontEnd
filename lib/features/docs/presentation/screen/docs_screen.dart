import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/docs_bloc.dart';
import '../../logic/docs_state.dart';
import '../../domain/entity/document_entity.dart';
import '../widgets/doc_header.dart';
import '../widgets/doc_info_row.dart';
import '../widgets/doc_actions.dart';
import '../widgets/pdf_preview_thumbnail.dart';
import 'docs_detail_screen.dart';
import '../../../../core/constants/app_icons.dart';

/// Màn home hiển thị preview tài liệu.
/// Từ đây nhấn → sang DocsDetailScreen.
class DocsScreen extends StatelessWidget {
  const DocsScreen({super.key});

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

            /// Layout: wide → chia đôi, mobile → full cột
            return SingleChildScrollView(
              padding: EdgeInsets.all(size.width * 0.04),
              child: isWide
                  ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Cột thông tin (bên trái)
                  Expanded(
                    flex: 5,
                    child: _buildInfoColumn(context, doc, state, isWide: true),
                  ),
                  const SizedBox(width: 20),

                  /// PDF preview (bên phải)
                  Expanded(
                    flex: 5,
                    child: PdfPreviewThumbnail(
                      onTap: () => _openDetail(context),
                      isFullSize: false,
                    ),
                  ),
                ],
              )
                  : _buildInfoColumn(context, doc, state, isWide: false),
            );
          },
        ),
      ),
    );
  }

  /// Cột chứa header + info + actions
  Widget _buildInfoColumn(
      BuildContext context,
      DocumentEntity doc,
      DocsLoaded state, {
        required bool isWide,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header + điều hướng vào màn chi tiết
        DocHeader(
          title: doc.title,
          isDetail: false,
          onTapArrow: () => _openDetail(context),
        ),

        const SizedBox(height: 12),

        /// Môn học – trường học
        DocInfoRow(text: doc.course, iconPath: AppAssets.folder),
        const SizedBox(height: 6),
        DocInfoRow(text: doc.school, iconPath: AppAssets.school),

        const SizedBox(height: 16),

        /// Save – Share – Report
        DocActions(state: state),

        const SizedBox(height: 20),

        /// Mobile: hiển thị PDF bên dưới info
        if (!isWide)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: PdfPreviewThumbnail(
              onTap: () => _openDetail(context),
              isFullSize: false,
            ),
          ),
      ],
    );
  }

  /// Điều hướng sang màn chi tiết.
  /// BlocProvider.value → giữ nguyên instance DocsBloc.
  void _openDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: BlocProvider.of<DocsBloc>(context),
          child: const DocsDetailScreen(),
        ),
      ),
    );
  }
}
