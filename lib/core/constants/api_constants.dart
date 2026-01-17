class ApiConstants {
  // Base URL
  // Web/iOS: dùng localhost
  // Android Emulator: dùng 10.0.2.2
  // static const String baseUrl = 'http://10.0.2.2:8081/api/v1';
  static const String baseUrl = 'http://10.10.3.165:8080/api/v1';
  static const String reviewBaseUrl = 'http://10.10.3.165:8080/api/v1';

  // Auth Endpoints
  static const String authLoginLocal = '/auth/login/local';
  static const String authLoginGoogle = '/auth/login/provider/google';
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register/local';
  static const String authRefresh = '/auth/refresh'; // Added Refresh Endpoint
  static const String authForgotPasswordRequest =
      '/auth/forgot-password/request';
  static const String authForgotPasswordConfirm =
      '/auth/forgot-password/confirm';
  // Document Endpoints
  static const String documents = '/documents';
  static const String popularDocumentsReal =
      '/documents/public/most-liked'; //  Real API
  static const String recentDocumentsReal = '/documents/public/newest'; //  Real API
  static const String searchDocuments = '/documents/search';

  // Admin Endpoints
  static const String adminStatsTotalDocuments = '/documents/admin/stats/documents/total';

  // User Endpoints
  static const String usersAll = '/users/all';
  static const String usersCount = '/users/count';
  static const String usersRegister = '/users/register';
  static const String usersUpdate = '/users/update';
  static const String usersUpdateImage = '/users/updateImage';
  static const String usersDelete = '/users/delete';

  static const String usersGetById = '/users/getUserByID';
  static const String usersIsPrivate = '/users/isPrivate';
  static const String usersExists = '/users/exists';

  static const String uploadDocument = '/';

  // Academic Endpoints
  static const String academicBaseUrl =
      'http://172.16.17.80:8080/api/v1/academics/';
  static const String academicUniversitiesFilter = 'universities/filter';
  static const String academicSubjectsFilter = 'subjects/filter';
  static const String academicUniversities = 'universities';
  static const String academicSubjects = 'subjects';
  static const String academicUniversityById =
      '/academics/universities/id'; //  New
  static const String academicSubjectById = '/academics/subjects/id'; //  New
  // =========================
  // USER DOCUMENT ENDPOINTS
  // =========================

  /// Base user document path
  static const String userDocuments = '/documents/user';
  static const String userUploadDocument = '/documents/user';
  static const String userUpdateDocument = '/documents/user';
  static const String userDeleteDocument = '/documents/user';
  static const String myDocuments = '/documents/user/me';
  static const String myNewestDocuments = '/documents/user/me/newest';
  static const String myDocumentHistory = '/documents/user/me/history';

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
