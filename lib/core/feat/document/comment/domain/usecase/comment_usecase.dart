import 'package:studydocs/core/feat/document/comment/domain/repository/review_repository.dart';

abstract interface class CommentUseCase {
  Future<void> call(String documentId, String content);
}

class CommentUseCaseImpl implements CommentUseCase {
  final ReviewRepository _reviewRepository;

  CommentUseCaseImpl(this._reviewRepository);

  @override
  Future<void> call(String documentId, String content) {
    return _reviewRepository.comment(documentId, content);
  }
}
