import 'package:studydocs/core/widgets/feat/document/information/domain/repository/review_repository.dart';

abstract interface class DislikeDocumentUseCase {
  Future<void> call(String documentId);
}

class DislikeDocumentUseCaseImpl implements DislikeDocumentUseCase {
  final ReviewRepository _reviewRepository;

  DislikeDocumentUseCaseImpl(this._reviewRepository);

  @override
  Future<void> call(String documentId) async {
    return _reviewRepository.dislikeDocument(documentId);
  }
}
