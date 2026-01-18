import '../model/document_library.dart';
import '../repository/library_repository.dart';

class GetSavedDocumentsUseCase {
  final LibraryRepository repository;

  GetSavedDocumentsUseCase(this.repository);

  Future<List<DocumentLibraryUI>> call() async {
    return await repository.getSavedDocuments();
  }
}
