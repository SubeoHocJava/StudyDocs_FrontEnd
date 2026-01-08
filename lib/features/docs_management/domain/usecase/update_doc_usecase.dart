import '../../../docs/domain/entity/document_entity.dart';
import '../repository/docs_management_repository.dart';

class UpdateDocUseCase {
  final DocsManagementRepository repository;

  UpdateDocUseCase(this.repository);

  Future<void> call(String id, DocumentEntity updatedDoc) =>
      repository.updateDocument(id, updatedDoc);
}
