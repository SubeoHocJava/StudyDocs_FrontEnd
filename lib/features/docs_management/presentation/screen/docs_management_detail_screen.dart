import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../docs/domain/entity/document_entity.dart';
import '../../logic/docs_management_bloc.dart';
import 'docs_edit_screen.dart';
import '../../../docs/presentation/widgets/comments_section.dart';
import '../../../docs/presentation/widgets/comment_input.dart';
import '../../../docs/presentation/widgets/document_preview_widget.dart';
import '../../../docs/presentation/widgets/like_dislike_row.dart'; // Import reuse
import 'package:url_launcher/url_launcher.dart';
// Imports for DocsBloc
import '../../../docs/domain/usecase/get_document_usecase.dart';
import '../../../docs/domain/usecase/toggle_like_usecase.dart';
import '../../../docs/domain/usecase/toggle_save_usecase.dart';
import '../../../docs/domain/usecase/post_comment_usecase.dart';
import '../../../docs/domain/usecase/react_review_usecase.dart';
import '../../../docs/logic/docs_bloc.dart';
import '../../../docs/logic/docs_event.dart';
import '../../../docs/logic/docs_state.dart' as docs_state; // Alias to avoid conflict if any
import '../../../docs/domain/repository/docs_repository.dart';

class DocsManagementDetailScreen extends StatefulWidget {
  final DocumentEntity document;
  final bool isAdminView;

  const DocsManagementDetailScreen({
    super.key,
    required this.document,
    this.isAdminView = false,
  });

  @override
  State<DocsManagementDetailScreen> createState() => _DocsManagementDetailScreenState();
}

class _DocsManagementDetailScreenState extends State<DocsManagementDetailScreen> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Use repository from Provider (Global context with Auth)
    final repository = context.read<DocsRepository>();

    return BlocProvider(
      create: (_) => DocsBloc(
        documentId: widget.document.id ?? '',
        getDocumentUseCase: GetDocumentUseCase(repository),
        toggleSaveUseCase: ToggleSaveUseCase(repository),
        toggleLikeUseCase: ToggleLikeUseCase(repository),
        postCommentUseCase: PostCommentUseCase(repository),
        reactReviewUseCase: ReactReviewUseCase(repository),
      )..add(const LoadDocDetails()),
      child: BlocConsumer<DocsBloc, docs_state.DocsState>(
        listener: (context, state) {
           if (state is docs_state.DocsLoaded) {
             setState(() {
                // Force verify expansion if needed, but state update should trigger rebuild
                // Just log or handle side effects
             });
           } else if (state is docs_state.DocsError) {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: ${state.message}")));
           }
        },
        builder: (context, state) {
           // If state is DocsError, we just use the initial data (widget.document) 
           // and let the listener show the SnackBar. We DO NOT replace the body.

           
           // Determine which document to show: enriched from state, or initial from widget
           DocumentEntity displayDoc = widget.document;
           if (state is docs_state.DocsLoaded) {
             displayDoc = state.docDetails;
           }

           return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Quản lý tài liệu",
          style: TextStyle(
            color: Color(0xFF3F51B5), // Match blueprint color
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF3F51B5)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Color(0xFF3F51B5)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.wb_sunny_outlined, color: Color(0xFF3F51B5)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state is docs_state.DocsLoading)
                const LinearProgressIndicator(), 

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    displayDoc.title.replaceAll('.pdf', ''), // Human, readable
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    // Navigate to Edit
                    // Navigate to Edit and wait for result
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<DocsManagementBloc>(),
                          child: DocsEditScreen(document: displayDoc),
                        ),
                      ),
                    );
                    // Refresh data after returning from Edit
                    if (context.mounted) {
                        context.read<DocsBloc>().add(const LoadDocDetails());
                    }
                  },
                  child: const Text("Chỉnh sửa", style: TextStyle(color: Color(0xFF3F51B5))),
                )
              ],
            ),
            const SizedBox(height: 8),
            
            // Info tags
            Row(children: [
                 const Icon(Icons.folder, size: 16, color: Colors.black87),
                 const SizedBox(width: 4),
                 Text(displayDoc.course, style: const TextStyle(color: Colors.blue)),
            ]),
            const SizedBox(height: 4),
            Row(children: [
                 const Icon(Icons.school, size: 16, color: Colors.black87),
                 const SizedBox(width: 4),
                 Text(displayDoc.school, style: const TextStyle(color: Colors.blue)),
            ]),

             const SizedBox(height: 12),
             SizedBox(
               height: 36,
               child: ElevatedButton.icon(
                 onPressed: () async {
                    final url = displayDoc.downloadUrl;
                    if (url.isNotEmpty) {
                        try {
                           final uri = Uri.parse(url);
                           // Open external app/browser for download
                           if (await canLaunchUrl(uri)) {
                             await launchUrl(uri, mode: LaunchMode.externalApplication);
                           } else {
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Không thể mở liên kết tải xuống")));
                           }
                        } catch (e) {
                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
                        }
                    } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Chưa có liên kết tải xuống")));
                    }
                 },
                 style: ElevatedButton.styleFrom(
                   backgroundColor: const Color(0xFF0000AA), // Blue color
                   foregroundColor: Colors.white,
                   padding: const EdgeInsets.symmetric(horizontal: 16),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                   elevation: 0,
                 ),
                 icon: const Icon(Icons.cloud_download, size: 18),
                 label: const Text("Tải về", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
               ),
             ),

            const SizedBox(height: 16),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Text("Năm học: ${displayDoc.year}"),
                    Row(children: [const Icon(Icons.description, size: 16, color: Colors.grey), const SizedBox(width: 4), Text("${displayDoc.pages} trang")]),
                ],
            ),

            const SizedBox(height: 20),
            const Text("Đăng tải bởi:", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Row(children: [
                const CircleAvatar(
                    child: Icon(Icons.person),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(displayDoc.uploader, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                        Text(displayDoc.school, style: const TextStyle(fontSize: 10, color: Colors.grey), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                )
            ]),

            const SizedBox(height: 12),
            if (!widget.isAdminView) LikeDislikeRow(doc: displayDoc),

            const SizedBox(height: 30),
            
             // PDF Preview (Reusable Widget)
             DocumentPreviewWidget(
                previewUrls: displayDoc.previewUrls,
                initialExpanded: _isExpanded,
                onExpand: () {
                    setState(() {
                        _isExpanded = true;
                    });
                },
             ),

             // EXPANDED CONTENT: Comments
             if (_isExpanded && !widget.isAdminView) ...[
                const SizedBox(height: 20),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("Bình luận", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                
                CommentsSection(
                  comments: displayDoc.comments, // Fetched from DocsBloc
                  currentPage: 0, 
                  commentsPerPage: 10,
                  onPageChange: (p) {},
                ),
                
                const SizedBox(height: 10),
                CommentInput(
                  onSend: (text) {
                     // Post comment via local DocsBloc
                     context.read<DocsBloc>().add(PostComment(text));
                  },
                ),
                const SizedBox(height: 40),
             ],
             

          ],
        ),
      ),
    );
        },
      ),
    );
  }
}
