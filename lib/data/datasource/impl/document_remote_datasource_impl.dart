import 'package:studydocs/core/network/dio_client.dart';
import '../document_remote_datasource.dart';

class DocumentRemoteDataSourceImpl implements DocumentRemoteDataSource {
  final DioClient _client;

  DocumentRemoteDataSourceImpl({DioClient? client}) : _client = client ?? DioClient();

  @override
  Future<dynamic> getDocuments({int? page, int? pageSize, String? query}) async {
    final Map<String, dynamic> params = {};
    if (page != null) params['page'] = page;
    if (pageSize != null) params['pageSize'] = pageSize;
    if (query != null && query.isNotEmpty) params['q'] = query;

    final response = await _client.get('education/documents', queryParameters: params);
    if (response.isSuccess) {
      return response.data;
    }
    throw Exception('Failed to load documents');
  }

  @override
  Future<dynamic> getDocumentById(String id) async {
    final response = await _client.get('education/documents/public/$id');
    if (response.isSuccess) {
      return response.data;
    }
    throw Exception('Failed to load document details');
  }

  @override
  Future<void> interactWithDocument(String documentId, String type) async {
    final response = await _client.post('education/documents/$documentId/interactions', data: {'type': type});
    if (!response.isSuccess) {
      throw Exception('Failed to interact with document');
    }
  }

  @override
  Future<void> bookmarkDocument(String documentId) async {
    final response = await _client.post('education/documents/$documentId/bookmark');
    if (!response.isSuccess) {
      throw Exception('Failed to bookmark document');
    }
  }

  @override
  Future<void> downloadDocument(String documentId) async {
    final response = await _client.post('education/documents/$documentId/download');
    if (!response.isSuccess) {
      throw Exception('Failed to download document');
    }
  }

  @override
  Future<dynamic> getMyDocuments() async {
    final response = await _client.get('education/documents/user/me');
    if (response.isSuccess) return response.data;
    throw Exception('Failed to load user documents');
  }

  @override
  Future<dynamic> getMyHistoryDocuments() async {
    final response = await _client.get('education/documents/user/me/history');
    if (response.isSuccess) return response.data;
    throw Exception('Failed to load history documents');
  }

  @override
  Future<dynamic> getMostLikedDocuments({int limit = 10}) async {
    final response = await _client.get('education/documents/public/most-liked', queryParameters: {'limit': limit});
    if (response.isSuccess) return response.data;
    throw Exception('Failed to load most liked documents');
  }

  @override
  Future<dynamic> getNewestDocuments({int limit = 10}) async {
    final response = await _client.get('education/documents/public/newest', queryParameters: {'limit': limit});
    if (response.isSuccess) return response.data;
    throw Exception('Failed to load newest documents');
  }

  @override
  Future<dynamic> uploadDocument(dynamic formData) async {
    final response = await _client.post('education/documents/upload', data: formData);
    if (response.isSuccess) return response.data;
    throw Exception('Failed to upload document');
  }

  @override
  Future<dynamic> initiateDocumentUpload(Map<String, dynamic> data) async {
    final response = await _client.post('education/documents/initiate', data: data);
    if (response.isSuccess) return response.data;
    throw Exception('Failed to initiate document upload');
  }

  @override
  Future<dynamic> completeDocumentUpload(String documentId, {Map<String, dynamic>? data}) async {
    final response = await _client.post('education/documents/$documentId/complete-upload', data: data ?? {});
    if (response.isSuccess) return response.data;
    throw Exception('Failed to complete document upload');
  }
}
