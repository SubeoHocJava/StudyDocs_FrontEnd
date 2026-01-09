import '../repository/docs_management_repository.dart';

class DeleteDocUseCase {
  final DocsManagementRepository repository;

  DeleteDocUseCase(this.repository);

  Future<void> call(String id) => repository.deleteDocument(id);
}
