abstract interface class DocumentRemoteDataSource {
  Future<dynamic> getDocuments({int? page, int? pageSize, String? query});
  Future<dynamic> getDocumentById(String id);
  Future<void> interactWithDocument(String documentId, String type);
  Future<void> bookmarkDocument(String documentId);
  Future<void> downloadDocument(String documentId);
  Future<dynamic> getMyDocuments();
  Future<dynamic> getMyHistoryDocuments();
  Future<dynamic> getMostLikedDocuments({int limit = 10});
  Future<dynamic> getNewestDocuments({int limit = 10});
  Future<dynamic> uploadDocument(dynamic formData);
  Future<dynamic> initiateDocumentUpload(Map<String, dynamic> data);
  Future<dynamic> completeDocumentUpload(String documentId, {Map<String, dynamic>? data});
}
