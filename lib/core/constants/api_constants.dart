class ApiConstants {
  // Base URL
  // Web/iOS: dùng localhost
  // Android Emulator: dùng 10.0.2.2
  // static const String baseUrl = 'http://10.0.2.2:8081/api/v1';
  static const String baseUrl = 'http://10.10.3.165:8080/api/v1';
  static const String reviewBaseUrl = 'http://172.16.17.80:8080/api/v1'; // Same as base in current local config

  // Auth Endpoints
  static const String authLoginLocal = '/auth/login/local';
  static const String authLoginGoogle = '/auth/login/provider/google';
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register/local';

  // Document Endpoints
  static const String documents = '/documents';
  static const String popularDocuments = '/documents/popular';  // Old mock endpoint
  static const String popularDocumentsReal = '/internal/documents/most-liked';  // ✅ Real API
  static const String recentDocuments = '/documents/recent';  // Old mock endpoint
  static const String recentDocumentsReal = '/internal/documents/newest';  // ✅ Real API
  static const String searchDocuments = '/documents/search';
  
  // User Endpoints
  static const String usersAll        = '/users/all';
  static const String usersCount      = '/users/count';
  static const String usersRegister   = '/users/register';
  static const String usersUpdate     = '/users/update';
  static const String usersUpdateImage= '/users/updateImage';
  static const String usersDelete     = '/users/delete';

  static const String usersGetById    = '/users/getUserByID';
  static const String usersIsPrivate  = '/users/isPrivate';
  static const String usersExists     = '/users/exists';

  static const String uploadDocument='/';
  
  // Academic Endpoints
  static const String academicBaseUrl = 'http://172.16.17.80:8080/api/v1/academics/';
  static const String academicUniversitiesFilter = 'universities/filter';
  static const String academicSubjectsFilter = 'subjects/filter';
  static const String academicUniversities = 'universities';
  static const String academicSubjects = 'subjects';
  static const String academicUniversityById = '/academics/universities/id';  //  New
  static const String academicSubjectById = '/academics/subjects/id';        //  New

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
