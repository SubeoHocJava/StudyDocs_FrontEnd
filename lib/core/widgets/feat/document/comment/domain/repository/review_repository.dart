import 'package:studydocs/core/widgets/feat/document/comment/domain/entity/comment.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/entity/author.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/entity/content.dart';

abstract interface class ReviewRepository {
  //Chỉ xử lý cho text cho hiện tại
  Future<void> comment(String documentId, String content);
  Future<void> replyComment(String documentId, String commentId, String content);
  Future<List<Comment>> getComments(String documentId);
  Future<List<Comment>> getReplies(String documentId, String commentId);
  Future<void> likeComment(String documentId, String commentId);
  Future<void> unlikeComment(String documentId, String commentId);
  Future<void> editComment(String documentId, String commentId, String content);
  Future<void> deleteComment(String documentId, String commentId);
}

class ReviewRepositoryImpl implements ReviewRepository {
  @override
  Future<void> comment(String documentId, String content) async {}

  @override
  Future<void> replyComment(String documentId, String commentId, String content) async {}

  @override
  Future<List<Comment>> getComments(String documentId) async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      Comment(
        id: 'root_A',
        documentId: documentId,
        contents: [TextBlock('Tài liệu này rất hữu ích, cảm ơn tác giả.')],
        author: const Author(
          id: 'author_A',
          fullName: 'Người Dùng A',
          avatarUrl: 'https://i.pravatar.cc/150?img=5',
        ),
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        likeCount: 5,
        replyCount: 2, 
      ),
      Comment(
        id: 'root_B',
        documentId: documentId,
        contents: [TextBlock('Xin hỏi ở phần 2 tác giả dùng công thức nào vậy?')],
        author: const Author(
          id: 'author_B',
          fullName: 'Người Dùng B',
          avatarUrl: 'https://i.pravatar.cc/150?img=8',
        ),
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        replyCount: 1,
      ),
    ];
  }

  @override
  Future<List<Comment>> getReplies(String documentId, String commentId) async {
    // Giả lập call API mất 1s
    await Future.delayed(const Duration(seconds: 1));

    if (commentId == 'root_A') {
      return [
        Comment(
          id: 'reply_mock_1_A',
          documentId: documentId,
          contents: [TextBlock('Tuyệt vời quá! Mình cũng nghĩ vậy.')],
          author: const Author(
            id: 'author_A1',
            fullName: 'Trần Bình',
            avatarUrl: 'https://i.pravatar.cc/150?img=11',
          ),
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
          replyToCommentId: commentId,
        ),
        Comment(
          id: 'reply_mock_2_A',
          documentId: documentId,
          contents: [TextBlock('Bài viết rất chỉn chu.')],
          author: const Author(
            id: 'author_A2',
            fullName: 'Nguyễn Văn C',
            avatarUrl: 'https://i.pravatar.cc/150?img=12',
          ),
          createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
          replyToCommentId: commentId,
        ),
      ];
    } else if (commentId == 'root_B') {
      return [
        Comment(
          id: 'reply_mock_1_B',
          documentId: documentId,
          contents: [TextBlock('Tác giả dùng công thức ABC ở trang 10 đó bạn.')],
          author: const Author(
            id: 'author_B1',
            fullName: 'Lê Cường',
            avatarUrl: 'https://i.pravatar.cc/150?img=14',
          ),
          createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
          replyToCommentId: commentId,
          replyCount: 1, // B1 có 1 reply
          children: [
            Comment(
              id: 'reply_B1_1',
              documentId: documentId,
              contents: [TextBlock('Cảm ơn bạn nhiều!')],
              author: const Author(
                id: 'author_B',
                fullName: 'Người Dùng B',
                avatarUrl: 'https://i.pravatar.cc/150?img=8',
              ),
              createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
              replyToCommentId: 'reply_mock_1_B',
            ),
          ],
        ),
      ];
    } else if (commentId == 'reply_mock_1_B') {
      return [
        Comment(
          id: 'reply_nested_mock_1_B1',
          documentId: documentId,
          contents: [TextBlock('Không có gì, chia sẻ cùng học mà!')],
          author: const Author(
            id: 'author_B1',
            fullName: 'Lê Cường',
            avatarUrl: 'https://i.pravatar.cc/150?img=14',
          ),
          createdAt: DateTime.now().subtract(const Duration(seconds: 30)),
          replyToCommentId: 'reply_mock_1_B',
          replyCount: 1,
          children: [
            Comment(
              id: 'reply_nested_mock_2_B2',
              documentId: documentId,
              contents: [TextBlock('Mình cũng thích phần 2.')],
              author: const Author(
                id: 'author_C',
                fullName: 'Người Dùng C',
                avatarUrl: 'https://i.pravatar.cc/150?img=2',
              ),
              createdAt: DateTime.now().subtract(const Duration(seconds: 15)),
              replyToCommentId: 'reply_nested_mock_1_B1',
              replyCount: 1,
              children: [
                Comment(
                  id: 'reply_nested_mock_3_B3',
                  documentId: documentId,
                  contents: [TextBlock('Phần đó viết rất dễ hiểu.')],
                  author: const Author(
                    id: 'author_D',
                    fullName: 'Người Dùng D',
                    avatarUrl: 'https://i.pravatar.cc/150?img=3',
                  ),
                  createdAt: DateTime.now().subtract(const Duration(seconds: 5)),
                  replyToCommentId: 'reply_nested_mock_2_B2',
                  children: const [],
                )
              ],
            )
          ],
        ),
      ];
    }
    
    return [];
  }

  @override
  Future<void> likeComment(String documentId, String commentId) async {}

  @override
  Future<void> unlikeComment(String documentId, String commentId) async {}

  @override
  Future<void> editComment(String documentId, String commentId, String content) async {}

  @override
  Future<void> deleteComment(String documentId, String commentId) async {}
}
