import '../../domain/entity/document_entity.dart';
import '../data_source/home_data_source.dart';

abstract class HomeRepository {
  Future<List<DocumentEntity>> getDocuments();
  Future<List<DocumentEntity>> getPopularDocuments();
  Future<List<DocumentEntity>> getRecentDocuments();
  Future<List<DocumentEntity>> searchDocuments(String query);
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource dataSource;

  HomeRepositoryImpl({required this.dataSource});

  @override
  Future<List<DocumentEntity>> getDocuments() async {
    try {
      final models = await dataSource.getDocuments();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get documents: $e');
    }
  }

  @override
  Future<List<DocumentEntity>> getPopularDocuments() async {
    try {
      final models = await dataSource.getPopularDocuments();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get popular documents: $e');
    }
  }

  @override
  Future<List<DocumentEntity>> getRecentDocuments() async {
    try {
      final models = await dataSource.getRecentDocuments();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get recent documents: $e');
    }
  }

  @override
  Future<List<DocumentEntity>> searchDocuments(String query) async {
    try {
      final models = await dataSource.searchDocuments(query);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to search documents: $e');
    }
  }
}

