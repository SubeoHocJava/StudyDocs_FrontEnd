import 'package:studydocs/core/widgets/feat/document/docs_card/domain/repository/document_repository.dart';

abstract interface class DownloadDocumentUseCase {
  Future<String?> call(String documentId);
}

class DownloadDocumentUseCaseImpl implements DownloadDocumentUseCase {
  final DocumentRepository _repository;

  DownloadDocumentUseCaseImpl(this._repository);

  @override
  Future<String?> call(String documentId) => _repository.download(documentId);
}
