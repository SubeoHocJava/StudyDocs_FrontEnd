class ApiConstants {
  // Base URL
  // Web/iOS: dùng localhost
  // Android Emulator: dùng 10.0.2.2
  static const String baseUrl = 'http://192.168.1.43:8082/api/v1';

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
  //User Endpoints
  static const String usersAll        = '/internal/users/all';
  static const String usersCount      = '/users/count';
  static const String usersRegister   = '/users/register';
  static const String usersUpdate     = '/users/update';
  static const String usersUpdateImage= '/users/updateImage';
  static const String usersDelete     = '/users/delete';

  static const String usersGetById    = '/users/getUserByID';
  static const String usersIsPrivate  = '/users/isPrivate';
  static const String usersExists     = '/users/exists';

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}