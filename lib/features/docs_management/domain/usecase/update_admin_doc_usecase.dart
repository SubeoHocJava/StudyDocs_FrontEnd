import '../../../docs/domain/entity/document_entity.dart';
import '../repository/docs_management_repository.dart';

class UpdateAdminDocUseCase {
  final DocsManagementRepository repository;

  UpdateAdminDocUseCase(this.repository);

  Future<void> call(String id, DocumentEntity updatedDoc) =>
      repository.updateAdminDocument(id, updatedDoc);
}
