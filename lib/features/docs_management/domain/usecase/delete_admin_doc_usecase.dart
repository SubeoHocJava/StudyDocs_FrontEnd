import '../repository/docs_management_repository.dart';

class DeleteAdminDocUseCase {
  final DocsManagementRepository repository;

  DeleteAdminDocUseCase(this.repository);

  Future<void> call(String id) => repository.deleteAdminDocument(id);
}
