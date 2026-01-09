import '../repository/docs_repository.dart';

class DownloadDocumentUseCase {
  final DocsRepository repository;

  DownloadDocumentUseCase(this.repository);

  Future<void> call() async {
    await repository.downloadDocument();
  }
}