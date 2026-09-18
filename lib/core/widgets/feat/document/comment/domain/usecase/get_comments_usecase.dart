import 'package:studydocs/core/widgets/feat/document/comment/domain/entity/comment.dart';
import 'package:studydocs/core/widgets/feat/document/comment/domain/repository/review_repository.dart';

abstract interface class GetCommentsUseCase {
  Future<List<Comment>> call(String documentId);
}

class GetCommentsUseCaseImpl implements GetCommentsUseCase {
  final ReviewRepository _reviewRepository;

  GetCommentsUseCaseImpl(this._reviewRepository);

  @override
  Future<List<Comment>> call(String documentId) async {
    return _reviewRepository.getComments(documentId);
  }
}
