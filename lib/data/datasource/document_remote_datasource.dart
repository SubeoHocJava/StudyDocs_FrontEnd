import 'package:dio/dio.dart';

abstract interface class DocumentRemoteDataSource {
  Future<dynamic> initiateDocumentUpload(Map<String, dynamic> request);
  Future<dynamic> completeDocumentUpload(String documentId, Map<String, dynamic> request);
  Future<dynamic> uploadDocument(FormData data);
  Future<dynamic> createDocument(Map<String, dynamic> request);
  Future<dynamic> getDocuments({int? page, int? pageSize, String? query});
  Future<dynamic> searchDocuments(String query);
  Future<dynamic> getDocumentById(String id);
  Future<void> interactWithDocument(String documentId, String type);
  Future<void> bookmarkDocument(String documentId);
  Future<void> downloadDocument(String documentId);
  Future<dynamic> getMyDocuments();
  Future<dynamic> getMySavedDocuments();
  Future<dynamic> getMyNewestDocuments();
  Future<dynamic> getMyHistoryDocuments();
  Future<dynamic> getMyDocumentCount();
  Future<dynamic> getMostLikedDocuments({int limit = 10});
  Future<dynamic> getNewestDocuments({int limit = 10});
  Future<dynamic> getAdminStatsTotalDocuments();
  Future<dynamic> getAdminStatsSystem();
}
