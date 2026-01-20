import '../repository/docs_repository.dart';

class DeleteDocumentUseCase {
  final DocsRepository repository;

  DeleteDocumentUseCase({required this.repository});

  Future<void> call(String id) async {
    return repository.deleteDocument(id);
  }
}
