import 'package:studydocs/core/feat/document/comment/domain/repository/review_repository.dart';

abstract interface class LikeCommentUseCase {
  Future<void> call(String documentId, String commentId);
}

class LikeCommentUseCaseImpl implements LikeCommentUseCase {
  final ReviewRepository _reviewRepository;

  LikeCommentUseCaseImpl(this._reviewRepository);

  @override
  Future<void> call(String documentId, String commentId) {
    return _reviewRepository.likeComment(documentId, commentId);
  }
}
