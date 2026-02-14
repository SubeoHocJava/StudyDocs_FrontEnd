import 'package:studydocs/core/feat/document/overview/domain/repository/document_repository.dart';

abstract interface class UnSaveUseCase {
  Future<void> call(String id);
}

class UnSaveUseCaseImpl implements UnSaveUseCase {
  final DocumentRepository _documentRepository;

  UnSaveUseCaseImpl(this._documentRepository);

  @override
  Future<void> call(String id) async {
    return await _documentRepository.unsave(id);
  }
}
