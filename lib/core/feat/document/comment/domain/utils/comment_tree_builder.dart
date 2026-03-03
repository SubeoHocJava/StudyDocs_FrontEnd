import 'package:studydocs/core/feat/document/comment/domain/entity/comment.dart';
import 'package:studydocs/core/feat/document/comment/domain/entity/comment_node.dart';

class CommentTreeBuilder {
  /// Xây dựng cây bình luận từ danh sách một chiều.
  static List<CommentNode> build(List<Comment> comments) {
    if (comments.isEmpty) return [];

    // 1. Sort O(N log N)
    final sortedComments = List<Comment>.from(comments)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final Map<String, _MutableCommentNode> nodeMap = {};
    final List<CommentNode> rootNodes = [];

    // 2. Khởi tạo tất cả Node rỗng O(N)
    for (final comment in sortedComments) {
      nodeMap[comment.id] = _MutableCommentNode(comment);
    }

    // 3. Ráp Node cha - con bằng tham chiếu bộ nhớ O(N)
    for (final comment in sortedComments) {
      final currentNode = nodeMap[comment.id]!;

      if (comment.replyToCommentId == null) {
        // Comment gốc
        rootNodes.add(currentNode.toImmutable());
      } else {
        // Có parent, lấy parent ra và chèn Node hiện tại vào danh sách children của parent
        final parentNode = nodeMap[comment.replyToCommentId];
        if (parentNode != null) {
          parentNode.children.add(currentNode.toImmutable());
        }
      }
    }

    return rootNodes;
  }
}

/// Helper class nội bộ cho phép add children trực tiếp, 
class _MutableCommentNode {
  final Comment comment;
  final List<CommentNode> children = [];

  _MutableCommentNode(this.comment);

  CommentNode toImmutable() {
    return CommentNode(comment: comment, children: children);
  }
}
