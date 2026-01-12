class ApiConstants {
  // Base URL
  // Web/iOS: dùng localhost
  // Android Emulator: dùng 10.0.2.2
  static const String baseUrl = 'http://192.168.1.181:8087/api/v1';
  static const String documentServiceUrl = 'http://10.0.2.2:8085/api/v1'; // Android Emulator
  static const String reviewServiceUrl = 'http://10.0.2.2:8086/api/v1';   // Android Emulator

  // Auth Endpoints
  static const String authLoginLocal = '/auth/login/local';
  static const String authLoginGoogle = '/auth/login/provider/google';
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';

  // Document Endpoints
  static const String documents = '/documents';
  static const String popularDocuments = '/documents/popular';
  static const String recentDocuments = '/documents/recent';
  static const String searchDocuments = '/documents/search';

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}