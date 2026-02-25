import 'package:studydocs/core/feat/document/comment/domain/repository/review_repository.dart';

abstract interface class DeleteCommentUseCase {
  Future<void> call(String documentId, String commentId);
}

class DeleteCommentUseCaseImpl implements DeleteCommentUseCase {
  final ReviewRepository _reviewRepository;

  DeleteCommentUseCaseImpl(this._reviewRepository);

  @override
  Future<void> call(String documentId, String commentId) {
    return _reviewRepository.deleteComment(documentId, commentId);
  }
}
