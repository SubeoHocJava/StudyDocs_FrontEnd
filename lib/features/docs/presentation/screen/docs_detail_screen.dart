import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/docs_bloc.dart';
import '../../logic/docs_state.dart';
import '../widgets/comment_input.dart';
import '../widgets/comments_section.dart';
import '../widgets/doc_actions.dart';
import '../doc_header.dart';
import '../widgets/docInfo_row.dart';
import '../widgets/like_dislike_row.dart';
import '../PdfPreview.dart';
import '../widgets/UploaderInfo.dart';
import '../../../../core/constants/app_icons.dart';

class DocsDetailScreen extends StatefulWidget {
  const DocsDetailScreen({super.key});

  @override
  _DocsDetailScreenState createState() => _DocsDetailScreenState();
}

class _DocsDetailScreenState extends State<DocsDetailScreen> {
  int _currentPage = 0;
  final int _commentsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DocsBloc, DocsState>(
          builder: (context, state) {
            if (state is DocsLoading || state is DocsInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is DocsLoaded) {
              final doc = state.docDetails;
              final comments = doc["comments"] as List<dynamic>;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DocHeader(
                      title: doc["title"],
                      isDetail: true,
                      onTapArrow: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 12),
                    DocInfoRow(text: doc["course"], iconPath: AppAssets.folder),
                    const SizedBox(height: 6),
                    DocInfoRow(text: doc["school"], iconPath: AppAssets.school),
                    const SizedBox(height: 16),
                    DocActions(state: state),
                    const SizedBox(height: 20),
                    Text("Năm học: ${doc["year"]}"),
                    const SizedBox(height: 12),
                    const Text("Đăng tải bởi:"),
                    UploaderInfo(doc: doc),
                    const SizedBox(height: 12),
                    LikeDislikeRow(doc: doc),
                    const SizedBox(height: 20),
                    PdfPreview(),
                    const SizedBox(height: 20),
                    CommentsSection(
                      comments: comments,
                      currentPage: _currentPage,
                      commentsPerPage: _commentsPerPage,
                      onPageChange: (page) => setState(() => _currentPage = page),
                    ),
                    const SizedBox(height: 20),
                    CommentInput(onSend: () {}),
                  ],
                ),
              );
            }
            return const Center(child: Text("Đã có lỗi xảy ra"));
          },
        ),
      ),
    );
  }
}
