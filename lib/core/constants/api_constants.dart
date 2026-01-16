class ApiConstants {
  // Base URL
  // Web/iOS: dùng localhost
  // Android Emulator: dùng 10.0.2.2
  // static const String baseUrl = 'http://10.0.2.2:8081/api/v1';
  static const String baseUrl = 'http://10.10.3.165:8080/api/v1';
  static const String documentServiceUrl = 'http://10.10.3.165:8080/api/v1'; // Use localhost for Web
  static const String reviewServiceUrl = 'http://10.10.3.165:8080/api/v1';   // Use localhost for Web
  // Auth Endpoints
  static const String authLoginLocal = '/auth/login/local';
  static const String authLoginGoogle = '/auth/login/provider/google';
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register/local';

  // Document Endpoints
  static const String documents = '/documents'; // Deprecated?
  static const String publicDocument = '/documents/public';
  static const String userDocument = '/documents/user';

  static const String popularDocuments = '/documents/public/most-liked';
  static const String recentDocuments = '/documents/public/newest';
  static const String searchDocuments = '/documents/search'; // TODO: Update if needed

  //Academic Endpoints
  // Academic service (StudyDocs Academic microservice)
  // Web/iOS: use localhost; Android emulator: use 10.0.2.2
  static const String academicBaseUrl = 'http://10.10.3.165:8080/api/v1/academics';
  static const String academicUniversitiesFilter = '/universities/filter';
  static const String academicSubjectsFilter = '/subjects/filter';
  static const String academicUniversities = '/universities';
  static const String academicSubjects = '/subjects';

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
