import 'package:flutter/material.dart';
import 'package:studydocs/core/feat/document/comment/domain/entity/comment.dart';
import 'package:studydocs/core/feat/document/comment/domain/entity/comment_node.dart';
import 'package:studydocs/core/feat/document/comment/presentation/comment_item.dart';

class CommentBlock extends StatelessWidget {
  final CommentNode node;
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
    // Giới hạn việc thụt lề
    final double leftPadding = depth == 1 ? 40.0 : 0.0;
    final double topPadding = depth > 0 ? 12.0 : 0.0;

    // Kích thước của ảnh avatar
    final double avatarSize = depth == 0 ? 50.0 : 38.0;
    final double avatarRadius = avatarSize / 2;

    return Padding(
      padding: EdgeInsets.only(left: leftPadding, top: topPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommentItem(
            comment: node.comment,
            parentComment: parentComment,
            avatarRadius: avatarRadius,
            avatarSize: avatarSize,
            onReply: onReply,
          ),
          // HIển thị các replies lồng bên dưới nếu có
          if (node.children.isNotEmpty)
            ...node.children.map((childNode) => CommentBlock(
                  node: childNode,
                  parentComment: node.comment,
                  depth: depth + 1,
                  onReply: onReply,
                )),
        ],
      ),
    );
  }
}
