import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/entity/comment.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/entity/content.dart';

class CommentBody extends StatelessWidget {
  final Comment comment;
  final Comment? parentComment;

  const CommentBody({
    super.key,
    required this.comment,
    this.parentComment,
  });

  @override
  Widget build(BuildContext context) {
    if (comment.contents.isEmpty || comment.contents.first is! TextBlock) {
      return const SizedBox.shrink();
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'Montserrat',
          color: AppColors.black,
          fontSize: 14,
        ),
        children: [
          if (parentComment != null)
            TextSpan(
              text: '@${parentComment!.author.fullName} ',
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          TextSpan(
            text: (comment.contents.first as TextBlock).text,
          ),
        ],
      ),
    );
  }
}
