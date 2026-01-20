import '../repository/docs_repository.dart';

class UpdateDocumentUseCase {
  final DocsRepository repository;

  UpdateDocumentUseCase({required this.repository});

  Future<void> call(String id, String title, String description, String year) async {
    return repository.updateDocument(id, title, description, year);
  }
}
