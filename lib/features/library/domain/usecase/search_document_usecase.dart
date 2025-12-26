import '../model/document_library.dart';
import '../repository/library_repository.dart';

class SearchDocumentUseCase {
  final LibraryRepository repository;

  SearchDocumentUseCase(this.repository);

  Future<List<DocumentLibraryUI>> call(String keyword) async {
    final documents = await repository.searchDocuments(keyword);
    return documents;
  }
}

