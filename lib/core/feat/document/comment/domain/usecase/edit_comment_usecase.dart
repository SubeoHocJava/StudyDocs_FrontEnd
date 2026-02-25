import 'package:studydocs/core/feat/document/comment/domain/repository/review_repository.dart';

abstract interface class EditCommentUseCase {
  Future<void> call(String documentId, String commentId, String content);
}

class EditCommentUseCaseImpl implements EditCommentUseCase {
  final ReviewRepository _reviewRepository;

  EditCommentUseCaseImpl(this._reviewRepository);

  @override
  Future<void> call(String documentId, String commentId, String content) {
    return _reviewRepository.editComment(documentId, commentId, content);
  }
}
