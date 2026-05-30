import '../config/env_config.dart';

class ApiConstants {
  static String get baseUrl => EnvConfig.apiBaseUrl;

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

/// =================================================
/// DOCUMENT
/// =================================================
class DocumentEndpoints {
  static const String base = 'documents';
  static const String public = '$base/public';
  static const String internal = '$base/internal';
  static const String user = '$base/user';

  static const String publicMostLiked = '$public/most-liked';
  static const String publicNewest = '$public/newest';
  static const String publicById = public;

  static const String search = '$base/search';

  static const String userBase = user;
  static const String myDocuments = '$user/me';
  static const String myNewest = '$user/me/newest';
  static const String myHistory = '$user/me/history';
  static const String myDocumentCount = '$user/me/count';

  static const String adminStats = '$base/admin/stats';
  static const String adminStatsDocuments = '$adminStats/documents/total';
  static const String adminStatsSystem = '$adminStats/system';
}

/// =================================================
/// REVIEW / REACTION
/// =================================================
class ReviewEndpoints {
  static const String base = 'reviews';

  static const String documentStats = '$base/document';
  static const String documentReact = '$base/document';

  static const String adminStats = '$base/admin/stats';
  static const String adminTotalLikes = '$adminStats/reactions/total-likes';
  static const String adminTotalReviews = '$adminStats/reviews/total';
  static const String myReactionCount = '$base/user/me/reactions/count';
  static const String userReviewCount = '$base/user/{{userId}}/count';
}

/// =================================================
/// ACADEMIC
/// =================================================
class AcademicEndpoints {
  static const String base = 'academics';
  static const String public = '$base/public';

  static const String universitiesFilter = '$base/universities/filter';
  static const String subjectsFilter = '$base/subjects/filter';
  static const String universities = '$base/universities';
  static const String subjects = '$base/subjects';

  static const String publicUniversityById = '$public/universities/id';
  static const String publicSubjectById = '$public/subjects/id';

  static const String documentsFilter = '$base/documents';
}

/// =================================================
/// FOLLOW
/// =================================================
class FollowEndpoints {
  static const String base = 'follows';

  static const String followers = '$base/followers';
  static const String following = '$base/following';
}
