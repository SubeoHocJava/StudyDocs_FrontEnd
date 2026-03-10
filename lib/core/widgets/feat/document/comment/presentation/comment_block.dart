import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/entity/comment.dart';
import 'package:studydocs/core/widgets/feat/document/comment/logic/document_comment_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/comment/logic/document_comment_event.dart';
import 'package:studydocs/core/widgets/feat/document/comment/presentation/comment_item.dart';
import 'package:studydocs/core/widgets/feat/document/comment/presentation/comment_editor.dart';

class CommentBlock extends StatefulWidget {
  final Comment node;
  final Comment? parentComment;
  final int depth;
  final void Function(Comment)? onReply;
  final String? replyingToCommentId;
  final void Function(String, String)? onSubmitReply;
  final VoidCallback? onCancelReply;

  const CommentBlock({
    super.key,
    required this.node,
    this.parentComment,
    this.depth = 0,
    this.onReply,
    this.replyingToCommentId,
    this.onSubmitReply,
    this.onCancelReply,
  });

  @override
  State<CommentBlock> createState() => _CommentBlockState();
}

class _CommentBlockState extends State<CommentBlock> {
  final TextEditingController _replyController = TextEditingController();
  final FocusNode _replyFocusNode = FocusNode();
  bool _isCollapsed = false;

  @override
  void didUpdateWidget(covariant CommentBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.replyingToCommentId == widget.node.id && oldWidget.replyingToCommentId != widget.node.id) {
       _replyController.text = '@${widget.node.author.fullName} ';
       _replyController.selection = TextSelection.fromPosition(TextPosition(offset: _replyController.text.length));
       _replyFocusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _replyController.dispose();
    _replyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Kích thước của ảnh avatar
    final double avatarSize = widget.depth == 0 ? 40.0 : 32.0;
    final double avatarRadius = avatarSize / 2;

    final double leftPadding = widget.depth == 0 ? 0.0 : 48.0;
        
    final double topPadding = widget.depth > 0 ? 12.0 : 0.0;

    final isReplyingToThis = widget.replyingToCommentId == widget.node.id;

    return Padding(
      padding: EdgeInsets.only(left: leftPadding, top: topPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommentItem(
            comment: widget.node,
            parentComment: widget.parentComment,
            avatarRadius: avatarRadius,
            avatarSize: avatarSize,
            onReply: widget.onReply,
          ),
          
          if (isReplyingToThis)
            Padding(
               padding: EdgeInsets.only(top: 8, left: avatarSize + 8.0),
               child: CommentEditor(
                 controller: _replyController,
                 focusNode: _replyFocusNode,
                 onCancel: () {
                    if (widget.onCancelReply != null) widget.onCancelReply!();
                 },
                 onSave: () {
                    if (widget.onSubmitReply != null) {
                       widget.onSubmitReply!(widget.node.id, _replyController.text);
                    }
                 },
               ),
            ),

          // HIển thị các replies lồng bên dưới nếu có
          if (widget.node.children.isNotEmpty && !_isCollapsed)
            ...widget.node.children.map((childNode) => CommentBlock(
                  key: ValueKey(childNode.id),
                  node: childNode,
                  parentComment: widget.node,
                  depth: widget.depth + 1,
                  onReply: widget.onReply,
                  replyingToCommentId: widget.replyingToCommentId,
                  onSubmitReply: widget.onSubmitReply,
                  onCancelReply: widget.onCancelReply,
                )),
                
          // Nút hành động cho phản hồi
          if (widget.node.replyCount > 0)
            if (_isCollapsed || widget.node.children.isEmpty)
              Padding(
                padding: EdgeInsets.only(top: 8, left: (avatarSize - 24) / 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(color: AppColors.gray, width: 1.5),
                          bottom: BorderSide(color: AppColors.gray, width: 1.5),
                        ),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isCollapsed = false;
                        });
                        if (widget.node.children.isEmpty) {
                          context.read<DocumentCommentBloc>().add(
                            LoadCommentRepliesRequested(widget.node.documentId, widget.node.id),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          'Hiển thị ${widget.node.replyCount} phản hồi',
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gray,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: EdgeInsets.only(top: 8, left: (avatarSize - 24) / 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(color: AppColors.gray, width: 1.5),
                          bottom: BorderSide(color: AppColors.gray, width: 1.5),
                        ),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (widget.node.replyCount > widget.node.children.length)
                      GestureDetector(
                        onTap: () {
                          context.read<DocumentCommentBloc>().add(
                            LoadCommentRepliesRequested(widget.node.documentId, widget.node.id),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            'Hiển thị thêm ${widget.node.replyCount - widget.node.children.length} phản hồi',
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.gray,
                            ),
                          ),
                        ),
                      ),
                    if (widget.node.replyCount > widget.node.children.length)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 4.0, left: 16.0, right: 16.0),
                        child: Text(
                          '•',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.gray,
                          ),
                        ),
                      ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isCollapsed = true;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: const Text(
                          'Thu gọn',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gray,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
