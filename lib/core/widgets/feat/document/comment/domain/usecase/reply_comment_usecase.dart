import 'package:studydocs/core/widgets/feat/document/comment/domain/repository/review_repository.dart';

abstract interface class ReplyCommentUseCase {
  Future<void> call(String documentId, String commentId, String content);
}

class ReplyCommentUseCaseImpl implements ReplyCommentUseCase {
  final ReviewRepository _reviewRepository;

  ReplyCommentUseCaseImpl(this._reviewRepository);

  @override
  Future<void> call(String documentId, String commentId, String content) {
    return _reviewRepository.replyComment(documentId, commentId, content);
  }
}
