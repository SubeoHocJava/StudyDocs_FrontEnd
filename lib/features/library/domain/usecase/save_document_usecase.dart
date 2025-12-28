import '../repository/library_repository.dart';

class SaveDocumentUseCase {
  final LibraryRepository repository;

  SaveDocumentUseCase(this.repository);

  Future<void> call(String documentId) async {
    // TODO: repository.saveDocument(documentId)
  }
}
