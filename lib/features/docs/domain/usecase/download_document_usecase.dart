import '../repository/docs_repository.dart';

class DownloadDocumentUseCase {
  final DocsRepository repository;

  DownloadDocumentUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.downloadDocument(id);
  Future<void> call({required String documentId}) async {
    await repository.downloadDocument(documentId: documentId);
  }
}