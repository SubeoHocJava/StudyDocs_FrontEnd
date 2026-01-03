class ApiConstants {
  // Base URL - Android Emulator dùng 10.0.2.2 để trỏ về localhost của máy host
  static const String baseUrl = 'http://10.0.2.2:8081/api';

  // Endpoints
  static const String documents = '/documents';
  static const String popularDocuments = '/documents/popular';
  static const String recentDocuments = '/documents/recent';
  static const String searchDocuments = '/documents/search';
  static const String authLoginLocal = '/auth/login/local';  // ← THÊM endpoint này
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}