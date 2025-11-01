import '../entity/document_entity.dart';
import '../../data/reponsitory/home_repository.dart';

class GetDocumentsUseCase {
  final HomeRepository repository;

  GetDocumentsUseCase({required this.repository});

  Future<List<DocumentEntity>> call() async {
    return await repository.getDocuments();
  }
}

class GetPopularDocumentsUseCase {
  final HomeRepository repository;

  GetPopularDocumentsUseCase({required this.repository});

  Future<List<DocumentEntity>> call() async {
    return await repository.getPopularDocuments();
  }
}

class GetRecentDocumentsUseCase {
  final HomeRepository repository;

  GetRecentDocumentsUseCase({required this.repository});

  Future<List<DocumentEntity>> call() async {
    return await repository.getRecentDocuments();
  }
}

class SearchDocumentsUseCase {
  final HomeRepository repository;

  SearchDocumentsUseCase({required this.repository});

  Future<List<DocumentEntity>> call(String query) async {
    return await repository.searchDocuments(query);
  }
}

