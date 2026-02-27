import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/constants/app_icons.dart';
import 'package:studydocs/core/feat/document/comment/domain/entity/comment.dart';
import 'package:studydocs/core/feat/document/comment/logic/document_comment_bloc.dart';
import 'package:studydocs/core/feat/document/comment/logic/document_comment_event.dart';
import 'package:studydocs/core/feat/document/comment/presentation/comment_content.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final Comment? parentComment;
  final double avatarRadius;
  final double avatarSize;
  final void Function(Comment)? onReply;

  const CommentItem({
    super.key,
    required this.comment,
    this.parentComment,
    required this.avatarRadius,
    required this.avatarSize,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        GestureDetector(
          onTap: () {
            context.read<DocumentCommentBloc>().add(
              AuthorClick(comment.author.id),
            );
          },
          child: CircleAvatar(
            radius: avatarRadius,
            backgroundColor: AppColors.backgroundLight,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: comment.author.avatarUrl,
                placeholder:
                    (context, url) => const CircularProgressIndicator(),
                errorWidget:
                    (context, url, error) => Image.asset(
                      AppAssets.avt,
                      width: avatarSize,
                      height: avatarSize,
                      fit: BoxFit.cover,
                    ),
                fit: BoxFit.cover,
                width: avatarSize,
                height: avatarSize,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Content
        Expanded(
          child: CommentContent(
            comment: comment,
            parentComment: parentComment,
            onReply: onReply,
          ),
        ),
      ],
    );
  }
}
