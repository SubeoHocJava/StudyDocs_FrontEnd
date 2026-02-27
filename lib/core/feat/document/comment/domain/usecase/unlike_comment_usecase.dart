import 'package:studydocs/core/feat/document/comment/domain/repository/review_repository.dart';

abstract interface class UnlikeCommentUseCase {
  Future<void> call(String documentId, String commentId);
}

class UnlikeCommentUseCaseImpl implements UnlikeCommentUseCase {
  final ReviewRepository _reviewRepository;

  UnlikeCommentUseCaseImpl(this._reviewRepository);

  @override
  Future<void> call(String documentId, String commentId) {
    return _reviewRepository.unlikeComment(documentId, commentId);
  }
}
