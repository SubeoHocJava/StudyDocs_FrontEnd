import 'package:studydocs/core/widgets/feat/document/docs_card/domain/repository/document_repository.dart';

abstract interface class BookmarkDocumentUseCase {
  Future<String?> call(String documentId);
}

class BookmarkDocumentUseCaseImpl implements BookmarkDocumentUseCase {
  final DocumentRepository _repository;

  const BookmarkDocumentUseCaseImpl(this._repository);

  @override
  Future<String?> call(String documentId) {
    return _repository.bookmark(documentId);
  }
}
