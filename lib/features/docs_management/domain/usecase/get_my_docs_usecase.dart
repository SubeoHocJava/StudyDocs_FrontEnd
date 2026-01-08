import '../../../docs/domain/entity/document_entity.dart';
import '../repository/docs_management_repository.dart';

class GetMyDocsUseCase {
  final DocsManagementRepository repository;

  GetMyDocsUseCase(this.repository);

  Future<List<DocumentEntity>> call() => repository.getMyDocuments();
}
