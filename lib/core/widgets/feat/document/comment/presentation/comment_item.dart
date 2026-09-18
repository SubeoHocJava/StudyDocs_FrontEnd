import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/widgets/common/user_avatar.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/entity/comment.dart';
import 'package:studydocs/core/widgets/feat/document/comment/logic/document_comment_bloc.dart';
import 'package:studydocs/core/widgets/feat/document/comment/logic/document_comment_event.dart';
import 'package:studydocs/screens/auth/presentation/cubit/auth_cubit.dart';
import 'package:studydocs/screens/auth/presentation/cubit/auth_state.dart';
import 'package:studydocs/core/widgets/feat/document/comment/presentation/comment_content.dart';

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
            context.push('/profile/${comment.author.id}');
          },
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              String avatarUrl = comment.author.avatarUrl;
              if (authState is AuthAuthenticated) {
                // Backend không trả về isMine, nên ta tự so sánh ID
                if (comment.author.id == authState.userId && authState.avatarUrl != null) {
                  avatarUrl = authState.avatarUrl!;
                }
              }
              return UserAvatar(
                avatarUrl: avatarUrl,
                radius: avatarRadius,
              );
            },
          ),
        ),
        const SizedBox(width: 8),
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
