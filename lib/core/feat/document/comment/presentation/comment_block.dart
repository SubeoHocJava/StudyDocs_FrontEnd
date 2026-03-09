import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/core/feat/document/comment/domain/entity/comment.dart';
import 'package:studydocs/core/feat/document/comment/logic/document_comment_bloc.dart';
import 'package:studydocs/core/feat/document/comment/logic/document_comment_event.dart';
import 'package:studydocs/core/feat/document/comment/presentation/comment_item.dart';

class CommentBlock extends StatelessWidget {
  final Comment node;
  final Comment? parentComment;
  final int depth;
  final void Function(Comment)? onReply;

  const CommentBlock({
    super.key,
    required this.node,
    this.parentComment,
    this.depth = 0,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    // Kích thước của ảnh avatar
    final double avatarSize = depth == 0 ? 40.0 : 32.0;
    final double avatarRadius = avatarSize / 2;

    // Khoảng cách từ lề trái đến đường gióng.
    // Ở cấp 0, avatar là 40, khoảng cách đến content là 12 -> viền trái của content là 52.
    // Ta muốn avatar của cấp 1 nằm thẳng từ tâm avatar cấp 0 xuống, hoặc thụt vào sao cho viền trái của avatar cấp 1 khớp với viền trái của content cấp 0.
    // Viền trái của content cấp 0 là 40 (avatar) + 12 (khoảng cách) = 52.
    // Để avatar cấp 1 nằm đúng vị trí này, leftPadding = 52.
    // Ở cấp 2 (avatar 32, khoảng cách 12), viền trái content cấp 1 là 52 + 32 + 12 = 96.
    final double leftPadding = depth == 0 
        ? 0.0 
        : (depth == 1 ? 52.0 : (depth == 2 ? 52.0 + 32.0 + 12.0 : 52.0 + 32.0 + 12.0));
        
    final double topPadding = depth > 0 ? 12.0 : 0.0;

    return Padding(
      padding: EdgeInsets.only(left: leftPadding, top: topPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommentItem(
            comment: node,
            parentComment: parentComment,
            avatarRadius: avatarRadius,
            avatarSize: avatarSize,
            onReply: depth >= 2 ? null : onReply,
          ),
          // HIển thị các replies lồng bên dưới nếu có
          if (node.children.isNotEmpty)
            ...node.children.map((childNode) => CommentBlock(
                  node: childNode,
                  parentComment: node,
                  depth: depth + 1,
                  onReply: onReply,
                )),
                
          // Nút hiển thị phản hồi sẽ hiển thị ở comment nếu tổng số reply phân trang lớn hơn số children đang có
          if (node.replyCount > node.children.length)
            Padding(
              padding: EdgeInsets.only(top: 8, left: (avatarSize - 24) / 2), // Căn đường kẻ vào giữa avatar
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
                      context.read<DocumentCommentBloc>().add(
                        LoadCommentRepliesRequested(node.documentId, node.id),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        'Hiển thị thêm phản hồi',
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
            ),
        ],
      ),
    );
  }
}
