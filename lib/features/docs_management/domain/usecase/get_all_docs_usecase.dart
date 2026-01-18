import '../../../docs/domain/entity/document_entity.dart';
import '../repository/docs_management_repository.dart';

class GetAllDocsUseCase {
  final DocsManagementRepository repository;

  GetAllDocsUseCase(this.repository);

  Future<List<DocumentEntity>> call() => repository.getAllDocuments();
}
