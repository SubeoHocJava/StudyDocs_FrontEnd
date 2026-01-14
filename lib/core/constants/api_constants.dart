class ApiConstants {
  // Base URL
  // Web/iOS: dùng localhost
  // Android Emulator: dùng 10.0.2.2
  // static const String baseUrl = 'http://10.0.2.2:8081/api/v1';
  static const String baseUrl = 'http://172.16.17.80:8080/api/v1';
  static const String documentServiceUrl = 'http://172.16.17.86:8085/api/v1'; // Use localhost for Web
  static const String reviewServiceUrl = 'http://172.16.17.86:8086/api/v1';   // Use localhost for Web
  // Auth Endpoints
  static const String authLoginLocal = '/auth/login/local';
  static const String authLoginGoogle = '/auth/login/provider/google';
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register/local';

  // Document Endpoints
  static const String documents = '/documents';
  static const String popularDocuments = '/documents/popular';
  static const String recentDocuments = '/documents/recent';
  static const String searchDocuments = '/documents/search';

  //Academic Endpoints
  // Academic service (StudyDocs Academic microservice)
  // Web/iOS: use localhost; Android emulator: use 10.0.2.2
  static const String academicBaseUrl = 'http://172.16.17.99:8083/api/v1/academics';
  static const String academicUniversitiesFilter = '/universities/filter';
  static const String academicSubjectsFilter = '/subjects/filter';
  static const String academicUniversities = '/universities';
  static const String academicSubjects = '/subjects';

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
