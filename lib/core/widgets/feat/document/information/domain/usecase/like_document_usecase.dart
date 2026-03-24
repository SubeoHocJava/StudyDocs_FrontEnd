import 'package:studydocs/core/widgets/feat/document/information/domain/repository/review_repository.dart';

abstract interface class LikeDocumentUseCase {
  Future<void> call(String documentId);
}

class LikeDocumentUseCaseImpl implements LikeDocumentUseCase {
  final ReviewRepository _reviewRepository;

  LikeDocumentUseCaseImpl(this._reviewRepository);

  @override
  Future<void> call(String documentId) async {
    return _reviewRepository.likeDocument(documentId);
  }
}
