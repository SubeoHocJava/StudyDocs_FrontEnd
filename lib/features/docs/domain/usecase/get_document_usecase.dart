import '../../../docs/domain/entity/document_entity.dart';
import '../repository/docs_repository.dart';

class GetDocumentUseCase {
  final DocsRepository repository;

  GetDocumentUseCase(this.repository);

  Future<DocumentEntity> call({required String documentId}) async {
    return await repository.getDocumentById(documentId);
  }
}