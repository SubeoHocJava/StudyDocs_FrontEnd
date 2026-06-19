

import '../entity/home_documents_page.dart';
import '../repository/home_repository.dart';

abstract interface class GetHomeDocumentsUseCase {
  Future<HomeDocumentsPage> call({
    required int page,
    required int pageSize,
  });
}

class GetHomeDocumentsUseCaseImpl implements GetHomeDocumentsUseCase {
  final HomeRepository _repository;

  const GetHomeDocumentsUseCaseImpl(this._repository);

  @override
  Future<HomeDocumentsPage> call({
    required int page,
    required int pageSize,
  }) {
    return _repository.getHomeDocuments(page: page, pageSize: pageSize);
  }
}
