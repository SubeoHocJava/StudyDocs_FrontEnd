
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/feat/document/comment/domain/entity/comment.dart';
import 'package:studydocs/core/feat/document/comment/domain/entity/author.dart';
import 'package:studydocs/core/feat/document/comment/domain/entity/content.dart';
import 'package:studydocs/core/feat/document/comment/logic/document_comment_bloc.dart';
import 'package:studydocs/core/feat/document/comment/logic/document_comment_event.dart';
import 'package:studydocs/core/feat/document/comment/logic/document_comment_state.dart';
import 'package:studydocs/core/feat/document/comment/presentation/comment_block.dart';

class DocumentCommentPresentation extends StatefulWidget {
  final String documentId;

  const DocumentCommentPresentation({super.key, required this.documentId});

  @override
  State<DocumentCommentPresentation> createState() =>
      _DocumentCommentPresentationState();
}

class _DocumentCommentPresentationState
    extends State<DocumentCommentPresentation> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Comment? _replyingTo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Mock dữ liệu ban đầu
      final mockData = [
        Comment(
          id: 'root_A',
          documentId: widget.documentId,
          contents: [TextBlock('Tài liệu này rất hữu ích, cảm ơn tác giả.')],
          author: const Author(
            id: 'author_A',
            fullName: 'Người Dùng A',
            avatarUrl: 'https://i.pravatar.cc/150?img=5',
          ),
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          likeCount: 5,
          replyCount: 2, // Có 2 reply
        ),
        Comment(
          id: 'root_B',
          documentId: widget.documentId,
          contents: [TextBlock('Xin hỏi ở phần 2 tác giả dùng công thức nào vậy?')],
          author: const Author(
            id: 'author_B',
            fullName: 'Người Dùng B',
            avatarUrl: 'https://i.pravatar.cc/150?img=8',
          ),
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          replyCount: 1, // Có 1 reply, mà bên trong đó lại có 1 reply nữa
        ),
      ];

      context.read<DocumentCommentBloc>().add(ReceivedData(mockData));
    });
  }

  void _handleReply(Comment comment) {
    setState(() {
      _replyingTo = comment;
      _controller.text = '@${comment.author.fullName} ';
    });
    // Di chuyển con trỏ chuột xuống cuối chữ
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
    _focusNode.requestFocus();
  }

  void _sendMessage() {
    final content = _controller.text.trim();
    if (content.isNotEmpty) {
      if (_replyingTo != null) {
        context.read<DocumentCommentBloc>().add(
              CommentReplied(widget.documentId, _replyingTo!.id, content),
            );
        setState(() {
          _replyingTo = null;
        });
      } else {
        context.read<DocumentCommentBloc>().add(
              CommentRequested(content, widget.documentId),
            );
      }
      _controller.clear();
      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                'Bình luận',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
        // Content
        Expanded(
          child: BlocBuilder<DocumentCommentBloc, DocumentCommentState>(
            builder: (context, state) {
              if (state is DocumentCommentLoaded) {
                if (state.comments.isEmpty) {
                  return Center(child: Text("Chưa có bình luận nào.", style: const TextStyle(fontFamily: 'Montserrat')));
                }
                
                final comments = state.comments;

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: comments.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return CommentBlock(
                      node: comments[index],
                      onReply: _handleReply,
                    );
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
        // Input Area
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: const TextStyle(fontFamily: 'Montserrat'),
                    decoration: InputDecoration(
                      hintText: _replyingTo != null
                          ? 'Đang trả lời ${_replyingTo!.author.fullName}...'
                          : 'Bạn nghĩ gì về tài liệu này...',
                      border: InputBorder.none,
                      hintStyle: const TextStyle(fontFamily: 'Montserrat', color: AppColors.gray),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryBlue,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.paperPlane,
                        color: AppColors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Gửi',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
