import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/entity/comment.dart';
import 'package:studydocs/core/utils/date_time_utils.dart';

class CommentHeader extends StatelessWidget {
  final Comment comment;

  const CommentHeader({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          comment.author.fullName,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            ),
        ),
        const SizedBox(width: 8),
        Text(
          DateTimeUtils.formatTimeAgo(comment.createdAt),
          style: const TextStyle(fontFamily: 'Montserrat', fontSize: 12, color: AppColors.gray),
        ),
      ],
    );
  }
}
