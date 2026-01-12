import '../../domain/entity/document_entity.dart';
import '../../domain/repository/docs_repository.dart';
import '../../../../data/datasource/docs_remote_datasource.dart';

class DocsRepositoryImpl implements DocsRepository {
  final DocsRemoteDataSource dataSource;

  DocsRepositoryImpl({required this.dataSource});

  @override
  Future<List<DocumentEntity>> getPublicDocuments({int page = 0, int size = 10}) =>
      dataSource.getPublicDocuments(page: page, size: size);

  @override
  Future<List<DocumentEntity>> getNewestDocuments({int limit = 10}) =>
      dataSource.getNewestDocuments(limit: limit);

  @override
  Future<List<DocumentEntity>> getMostLikedDocuments({int limit = 10}) =>
      dataSource.getMostLikedDocuments(limit: limit);

  @override
  Future<DocumentEntity> getDocumentById(String id) =>
      dataSource.getDocumentById(id);

  @override
  Future<void> reactToDocument(String id, String type) =>
      dataSource.reactToDocument(id, type);
}
