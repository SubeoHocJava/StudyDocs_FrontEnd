import 'package:studydocs/core/widgets/feat/document/docs_card/domain/repository/document_repository.dart';

abstract interface class LikeDocumentUseCase {
  Future<String?> call(String documentId);
}

class LikeDocumentUseCaseImpl implements LikeDocumentUseCase {
  final DocumentRepository _repository;

  LikeDocumentUseCaseImpl(this._repository);

  @override
  Future<String?> call(String documentId) => _repository.like(documentId);
}
