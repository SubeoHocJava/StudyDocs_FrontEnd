abstract interface class ReviewRepository {
  //Chỉ xử lý cho text cho hiện tại
  Future<void> comment(String documentId, String content);
  Future<void> replyComment(String documentId, String commentId, String content);
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
  Future<void> likeComment(String documentId, String commentId) async {}

  @override
  Future<void> unlikeComment(String documentId, String commentId) async {}

  @override
  Future<void> editComment(String documentId, String commentId, String content) async {}

  @override
  Future<void> deleteComment(String documentId, String commentId) async {}
}
