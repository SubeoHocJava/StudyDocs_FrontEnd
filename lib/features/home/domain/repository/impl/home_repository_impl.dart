import 'package:studydocs/data/datasource/home_remote_datasource.dart';
import 'package:studydocs/features/home/domain/entity/document_entity.dart';
import 'package:studydocs/features/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<DocumentEntity>> getDocuments() async {
    try {
      final models = await remoteDataSource.getDocuments();
      return models.map((model) => DocumentEntity.fromModel(model)).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get documents - $e');
    }
  }

  @override
  Future<List<DocumentEntity>> getPopularDocuments() async {
    try {
      final models = await remoteDataSource.getPopularDocuments();
      return models.map((model) => DocumentEntity.fromModel(model)).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get popular documents - $e');
    }
  }

  @override
  Future<List<DocumentEntity>> getRecentDocuments() async {
    try {
      final models = await remoteDataSource.getRecentDocuments();
      return models.map((model) => DocumentEntity.fromModel(model)).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get recent documents - $e');
    }
  }

  @override
  Future<List<DocumentEntity>> searchDocuments(String query) async {
    try {
      final models = await remoteDataSource.searchDocuments(query);
      return models.map((model) => DocumentEntity.fromModel(model)).toList();
    } catch (e) {
      throw Exception('Repository: Failed to search documents - $e');
    }
  }
}