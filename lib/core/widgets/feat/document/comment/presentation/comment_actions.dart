import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/entity/comment.dart';
import 'package:studydocs/core/widgets/feat/document/comment/logic/document_comment_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/comment/logic/document_comment_event.dart';

class CommentActions extends StatelessWidget {
  final Comment comment;
  final VoidCallback? onReply;
  final VoidCallback onEdit;

  const CommentActions({
    super.key,
    required this.comment,
    this.onReply,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (comment.isLiked) {
              context.read<DocumentCommentBloc>().add(CommentUnliked(comment.documentId, comment.id));
            } else {
              context.read<DocumentCommentBloc>().add(CommentLiked(comment.documentId, comment.id));
            }
          },
          child: Row(
            children: [
              Image.asset(
                comment.isLiked ? AppAssets.fullLike : AppAssets.outlineLike,
                width: 16,
                height: 16,
                color: comment.isLiked ? AppColors.primary : AppColors.gray,
              ),
              if (comment.likeCount > 0) ...[
                const SizedBox(width: 4),
                Text(
                  '${comment.likeCount}',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: comment.isLiked ? AppColors.primary : AppColors.gray,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: onReply,
          child: const Text(
            'Phản hồi',
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: AppColors.gray,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Spacer(),
        if (comment.isMine) ...[
          GestureDetector(
            onTap: onEdit,
            child: const Icon(Icons.edit, size: 16, color: AppColors.gray),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              context.read<DocumentCommentBloc>().add(CommentDeleted(comment.documentId, comment.id));
            },
            child: Image.asset(AppAssets.bin, width: 16, height: 16, color: AppColors.danger),
          ),
        ],
      ],
    );
  }
}
