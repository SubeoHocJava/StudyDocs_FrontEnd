import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:studydocs/features/docs/presentation/screen/reviews_screen.dart';
import '../../../../core/widgets/header.dart';
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
import '../../../../core/widgets/bottom_nav.dart';
import '../../../../core/router/app_router.dart';
import 'package:studydocs/features/auth/presentation/bloc/auth_status_cubit.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/utils/auth_utils.dart'; // Import helper
import 'docs_edit_screen.dart';


class DocsDetailScreen extends StatefulWidget {
  const DocsDetailScreen({super.key});

  @override
  State<DocsDetailScreen> createState() => _DocsDetailScreenState();
}

class _DocsDetailScreenState extends State<DocsDetailScreen> {
  int _pdfPageIndex = 0;        // ← Biến riêng cho PDF preview
  int _commentPageIndex = 0;    // ← Biến riêng cho phân trang comment
  bool _isExpanded = false;     // ← Trạng thái xem thêm
  final int _commentsPerPage = 5;

  bool _checkAuth() {
    final authCubit = context.read<AuthStatusCubit>();
    if (!authCubit.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vui lòng đăng nhập để thực hiện tính năng này'),
          backgroundColor: AppColors.headerForeground,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Đăng nhập',
            textColor: Colors.white,
            onPressed: () {
               showLoginModal(context);
            },
          ),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;

    return Scaffold(
      appBar: const Header(isDefault: false, headerTitle: 'Chi tiết tài liệu'),
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
      bottomNavigationBar: BottomNav(
        currentIndex: -1,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.home);
              break;
            case 1:
              context.go(AppRoutes.library);
              break;
            case 2:
              context.go(AppRoutes.explore);
              break;
            case 3:
              context.go(AppRoutes.notifications);
              break;
          }
        },
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
        itemCount: _isExpanded ? previewUrls.length : (previewUrls.isNotEmpty ? 1 : 0),
        physics: _isExpanded ? null : const NeverScrollableScrollPhysics(), // Disable swipe if not expanded
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
    // Check Auth for Ownership
    final authState = context.read<AuthStatusCubit>().state;
    final isOwner = authState is AuthAuthenticated && authState.userId == doc.uploaderId;

    return BlocListener<DocsBloc, DocsState>(
      listener: (context, state) {
        if (state is DocsDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã xóa tài liệu thành công')),
          );
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRoutes.home);
          }
        }
        if (state is DocsUpdated) { // Handle Update Success
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cập nhật tài liệu thành công')),
          );
        }
        if (state is DocsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Column(
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
          
          // Owner Actions
          if (isOwner) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // Navigate to Edit Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<DocsBloc>(),
                          child: DocsEditScreen(doc: doc),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text("Chỉnh sửa"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => _confirmDelete(context),
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text("Xóa"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 16),
          DocActions(state: state),
          const SizedBox(height: 16),
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

          // Mobile: Render PDF/Image Viewer
          if (MediaQuery.of(context).size.width <= 600)
            _buildPdfViewer(doc.previewUrls, doc.pages),
          if (MediaQuery.of(context).size.width <= 600) const SizedBox(height: 16),

          // Button "Xem thêm" (See More) - Only visible when NOT expanded
          if (!_isExpanded && MediaQuery.of(context).size.width <= 600)
             Container(
               width: double.infinity,
               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
               child: OutlinedButton.icon(
                 onPressed: () {
                   setState(() {
                     _isExpanded = true;
                   });
                 },
                 icon: const Icon(Icons.expand_more),
                 label: const Text("Xem thêm chi tiết & Bình luận"),
                 style: OutlinedButton.styleFrom(
                   padding: const EdgeInsets.symmetric(vertical: 12),
                   side: BorderSide(color: Theme.of(context).primaryColor),
                 ),
               ),
             ),

          // Expanded Content: Comments and Input
          if (_isExpanded || MediaQuery.of(context).size.width > 600) ...[
              const SizedBox(height: 16),
              const Divider(),
              
              CommentsSection(
                comments: doc.comments,
                currentPage: _commentPageIndex,
                commentsPerPage: _commentsPerPage,
                onPageChange: (page) => setState(() => _commentPageIndex = page),
              ),
              
              if (doc.comments.isNotEmpty)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (_) => BlocProvider.value(
                             value: context.read<DocsBloc>(),
                             child: ReviewsScreen(
                               documentId: doc.id!, 
                               documentTitle: doc.title
                             ),
                           ),
                         ),
                       );
                    },
                    child: const Text("Xem tất cả bình luận"),
                  ),
                ),
                
              const SizedBox(height: 10),
              CommentInput(
                onSend: (text) {
                  if (_checkAuth()) {
                    context.read<DocsBloc>().add(PostComment(text));
                  }
                },
              ),
              const SizedBox(height: 40),
          ],
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xóa tài liệu?"),
        content: const Text("Hành động này không thể hoàn tác. Bạn có chắc chắn muốn xóa không?"),
        actions: [
          TextButton(
            child: const Text("Hủy"),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: const Text("Xóa", style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<DocsBloc>().add(const DeleteDocument());
            },
          ),
        ],
      ),
    );
  }
}