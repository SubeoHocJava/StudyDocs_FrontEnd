
import '../model/document_library.dart';
import '../repository/library_repository.dart';

class LoadDocumentUseCase {
  final LibraryRepository repository;

  LoadDocumentUseCase(this.repository);

  Future<List<DocumentLibraryUI>> call(String keyword) async {
    final documents = await repository.loadDocuments(keyword);
    return documents;
  }
}

