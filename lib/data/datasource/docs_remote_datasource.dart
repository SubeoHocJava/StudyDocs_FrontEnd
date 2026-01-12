import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../../features/docs/data/model/document_model.dart';
import '../../features/docs/domain/entity/document_entity.dart';

abstract class DocsRemoteDataSource {
  Future<List<DocumentEntity>> getPublicDocuments({int page = 0, int size = 10});
  Future<List<DocumentEntity>> getNewestDocuments({int limit = 10});
  Future<List<DocumentEntity>> getMostLikedDocuments({int limit = 10});
  Future<DocumentEntity> getDocumentById(String id);
  Future<void> reactToDocument(String id, String type);
}

class DocsRemoteDataSourceImpl implements DocsRemoteDataSource {
  final DioClient dioClient;

  DocsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<DocumentEntity>> getPublicDocuments({int page = 0, int size = 10}) async {
    final response = await dioClient.get(
      '${ApiConstants.documentServiceUrl}/documents/public',
      queryParameters: {'page': page, 'size': size},
    );
    // Handle Page<DocumentResponse>
    final data = response.data;
    if (data is Map && data.containsKey('content')) {
      final content = data['content'] as List;
      return content.map((json) => DocumentModel.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<List<DocumentEntity>> getNewestDocuments({int limit = 10}) async {
    final response = await dioClient.get(
      '${ApiConstants.documentServiceUrl}/documents/public/newest',
      queryParameters: {'limit': limit},
    );
    final data = response.data;
    return (data as List).map((json) => DocumentModel.fromJson(json)).toList();
  }

  @override
  Future<List<DocumentEntity>> getMostLikedDocuments({int limit = 10}) async {
    final response = await dioClient.get(
      '${ApiConstants.documentServiceUrl}/documents/public/most-liked',
      queryParameters: {'limit': limit},
    );
    final data = response.data;
    return (data as List).map((json) => DocumentModel.fromJson(json)).toList();
  }

  @override
  Future<DocumentEntity> getDocumentById(String id) async {
    final response = await dioClient.get(
      '${ApiConstants.documentServiceUrl}/documents/public/$id',
    );
    return DocumentModel.fromJson(response.data);
  }

  @override
  Future<void> reactToDocument(String id, String type) async {
    // Review Service handles Document Reactions
    await dioClient.post(
      '${ApiConstants.reviewServiceUrl}/reviews/document/$id/react',
      queryParameters: {'type': type},
    );
  }
}
