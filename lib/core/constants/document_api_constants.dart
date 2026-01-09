class DocumentApiConstants {
  // Base URL for Document Service
  // TODO: Verify port number
  static const String baseUrl = 'http://10.0.2.2:8081/api';

  // Document Endpoints
  static const String documents = '/documents';
  static const String popularDocuments = '/documents/popular';
  static const String recentDocuments = '/documents/recent';
  static const String searchDocuments = '/documents/search';
}
