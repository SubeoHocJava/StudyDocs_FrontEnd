import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/feat/document/comment/domain/entity/comment.dart';
import 'package:studydocs/core/feat/document/comment/domain/entity/content.dart';
import 'package:studydocs/core/feat/document/comment/logic/document_comment_bloc.dart';
import 'package:studydocs/core/feat/document/comment/logic/document_comment_event.dart';
import 'package:studydocs/core/feat/document/comment/presentation/comment_actions.dart';
import 'package:studydocs/core/feat/document/comment/presentation/comment_body.dart';
import 'package:studydocs/core/feat/document/comment/presentation/comment_editor.dart';
import 'package:studydocs/core/feat/document/comment/presentation/comment_header.dart';

class CommentContent extends StatefulWidget {
  final Comment comment;
  final Comment? parentComment;
  final void Function(Comment)? onReply;

  const CommentContent({
    super.key,
    required this.comment,
    this.parentComment,
    this.onReply,
  });

  @override
  State<CommentContent> createState() => _CommentContentState();
}

class _CommentContentState extends State<CommentContent> {
  bool _isEditing = false;
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(
      text: widget.comment.contents.isNotEmpty && widget.comment.contents.first is TextBlock
          ? (widget.comment.contents.first as TextBlock).text
          : "",
    );
  }

  @override
  void didUpdateWidget(covariant CommentContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.comment.contents != widget.comment.contents) {
      _editController.text = widget.comment.contents.isNotEmpty && widget.comment.contents.first is TextBlock
          ? (widget.comment.contents.first as TextBlock).text
          : "";
    }
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  void _saveEdit() {
    final newText = _editController.text.trim();
    if (newText.isNotEmpty) {
      context.read<DocumentCommentBloc>().add(
            CommentEdited(widget.comment.documentId, widget.comment.id, newText),
          );
    }
    setState(() {
      _isEditing = false;
    });
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _editController.text = widget.comment.contents.isNotEmpty && widget.comment.contents.first is TextBlock
          ? (widget.comment.contents.first as TextBlock).text
          : "";
    });
  }

  void _startEdit() {
    setState(() {
      _isEditing = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommentHeader(comment: widget.comment),
          const SizedBox(height: 4),
          if (_isEditing)
            CommentEditor(
              controller: _editController,
              onCancel: _cancelEdit,
              onSave: _saveEdit,
            )
          else ...[
            CommentBody(
              comment: widget.comment,
              parentComment: widget.parentComment,
            ),
            const SizedBox(height: 8),
            CommentActions(
              comment: widget.comment,
              onReply: widget.onReply != null ? () => widget.onReply!(widget.comment) : null,
              onEdit: _startEdit,
            ),
          ],
        ],
      ),
    );
  }
}
