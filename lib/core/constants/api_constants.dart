class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://192.168.1.56:8087/api/v1/';

  // Endpoints
  static const String documents = '/documents';
  static const String popularDocuments = '/documents/popular';
  static const String recentDocuments = '/documents/recent';
  static const String searchDocuments = '/documents/search';

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}