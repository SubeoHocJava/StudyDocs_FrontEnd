class ApiConstants {
  // Base URL: Always end with / to work correctly with Dio relative paths
  static const String baseUrl = 'http://10.10.3.165:8080/api/v1/';
// Follow Endpoints
  static const String follows = 'follows';
  static const String followsFollowers = 'follows/followers';
  static const String followsFollowing = 'follows/following';

  static const String documentServiceUrl = 'http://10.10.3.165:8080/api/v1'; // Use localhost for Web
  static const String reviewServiceUrl = 'http://10.10.3.165:8080/api/v1';   // Use localhost for Web

  // Document Endpoints
  static const String documents = '/documents';
  static const String publicDocument = '/documents/public'; // Corrected Path
  static const String popularDocumentsReal =
      '/documents/public/most-liked'; //  Real API
  static const String popularDocuments = '/documents/public/most-liked';
  static const String recentDocumentsReal = '/documents/public/newest'; //  Real API
  static const String recentDocuments = '/documents/public/newest';
  static const String searchDocuments = '/documents/search';
  static const String authLoginLocal = 'auth/login/local';
  static const String authLoginGoogle = 'auth/login/provider/google';
  static const String authLogin = 'auth/login';
  static const String authRegister = 'auth/register/local';
  static const String authRefresh = 'auth/refresh';
  static const String authForgotPasswordRequest = 'auth/forgot-password/request';
  static const String authForgotPasswordConfirm = 'auth/forgot-password/confirm';

  // Review Endpoints (Relative to baseUrl)
  static const String reviewBase = 'reviews';
  static const String reviewDocumentStats = 'reviews/document'; // Append /$id/stats
  static const String reviewDocumentReact = 'reviews/document'; // Append /$id/react

  // Admin Endpoints
  static const String adminStatsTotalDocuments = 'documents/admin/stats/documents/total';

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

 //  New
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


  // Academic Endpoints (Relative to baseUrl)
  static const String academicUniversitiesFilter = 'academics/universities/filter';
  static const String academicSubjectsFilter = 'academics/subjects/filter';
  static const String academicUniversities = 'academics/universities';
  static const String academicSubjects = 'academics/subjects';
  static const String academicUniversityById = 'academics/public/universities/id';
  static const String academicSubjectById = 'academics/public/subjects/id';
  static const String academicDocumentsFilter = 'academics/documents';
  static const String publicDocumentById = 'documents/public';



  // Statistic Endpoints
  static const String adminStatsSystem = 'documents/admin/stats/system';
  static const academicBaseUrl='';



  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}