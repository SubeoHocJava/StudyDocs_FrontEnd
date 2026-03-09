import 'package:studydocs/core/feat/document/comment/domain/entity/comment.dart';
import 'package:studydocs/core/feat/document/comment/domain/repository/review_repository.dart';

abstract interface class GetCommentRepliesUseCase {
  Future<List<Comment>> call(String documentId, String commentId);
}

class GetCommentRepliesUseCaseImpl implements GetCommentRepliesUseCase {
  final ReviewRepository _reviewRepository;

  GetCommentRepliesUseCaseImpl(this._reviewRepository);

  @override
  Future<List<Comment>> call(String documentId, String commentId) {
    return _reviewRepository.getReplies(documentId, commentId);
  }
}
