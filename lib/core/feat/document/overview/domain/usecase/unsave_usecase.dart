import 'package:studydocs/core/feat/document/overview/domain/repository/document_repository.dart';

abstract interface class UnSaveUseCase {
  Future<void> call(String id);
}

class UnSSaveUseCaseImpl implements UnSaveUseCase {
  final DocumentRepository _documentRepository;

  UnSSaveUseCaseImpl(this._documentRepository);

  @override
  Future<void> call(String id) async {
    return await _documentRepository.unsave(id);
  }
}
