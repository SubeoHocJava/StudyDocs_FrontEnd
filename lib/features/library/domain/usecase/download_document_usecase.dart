import '../repository/library_repository.dart';

class DownloadDocumentUseCase {
  final LibraryRepository repository;

  DownloadDocumentUseCase(this.repository);

  Future<void> call(String documentId) async {
    // TODO: repository.downloadDocument(documentId)
  }
}
