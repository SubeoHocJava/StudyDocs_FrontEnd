import 'package:studydocs/core/feat/document/overview/domain/repository/document_repository.dart';

abstract interface class SaveUseCase {
  Future<void> call(String id);
}

class SaveUseCaseImpl implements SaveUseCase {
  final DocumentRepository _documentRepository;

  SaveUseCaseImpl(this._documentRepository);

  @override
  Future<void> call(String id) async {
    return await _documentRepository.save(id);
  }
}
