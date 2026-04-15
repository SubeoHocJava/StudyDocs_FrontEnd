import 'package:studydocs/sceens/user/document/domain/entity/document.dart';
import 'package:studydocs/sceens/user/document/domain/repository/document_repository.dart';

abstract interface class GetDocumentUseCase {
  Future<Document> call(String id);
}

class GetDocumentUseCaseImpl implements GetDocumentUseCase {
  final DocumentRepository _documentRepository;

  GetDocumentUseCaseImpl(this._documentRepository);

  @override
  Future<Document> call(String id) async {
    return await _documentRepository.getById(id);
  }
}
