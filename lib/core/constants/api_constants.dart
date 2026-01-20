class ApiConstants {
  static const String _base = "http://172.16.16.81:8080/api/v1";
  static const String baseUrl = '$_base/';

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

/// =================================================
/// AUTH
/// =================================================
class AuthEndpoints {
  static const String base = 'auth';

  static const String login = '$base/login';
  static const String loginLocal = '$base/login/local';
  static const String loginGoogle = '$base/login/provider/google';
  static const String register = '$base/register/local';
  static const String refresh = '$base/refresh';
  static const String forgotPasswordRequest = '$base/forgot-password/request';
  static const String forgotPasswordConfirm = '$base/forgot-password/confirm';
}

/// =================================================
/// USER
/// =================================================
class UserEndpoints {
  static const String base = 'users';

  static const String all = '$base/all';
  static const String count = '$base/count';
  static const String register = '$base/register';
  static const String update = '$base/update';
  static const String updateImage = '$base/updateImage';
  static const String delete = '$base/delete';
  static const String getById = '$base/getUserByID';
  static const String isPrivate = '$base/isPrivate';
  static const String exists = '$base/exists';

  // Document interactions via User service
  static const String documentSave = '$base/document/save';
  static const String documentSaved = '$base/document/saved';

  //admin
  static const String updateUserByAdmin = '$base/update/admin';

}

/// =================================================
/// DOCUMENT
/// =================================================
class DocumentEndpoints {
  static const String base = 'documents';
  static const String public = '$base/public';
  static const String internal = '$base/internal'; // Reserved for internal use
  static const String user = '$base/user';

  // Public
  static const String publicMostLiked = '$public/most-liked';
  static const String publicNewest = '$public/newest';
  static const String publicById = public; // Append /$id

  static const String search = '$base/search';

  // User specific
  static const String userBase = user;
  static const String myDocuments = '$user/me';
  static const String myNewest = '$user/me/newest';
  static const String myHistory = '$user/me/history';

  // ✅ ADD — USER DOCUMENT COUNT
  // GET /api/v1/documents/user/me/count
  static const String myDocumentCount = '$user/me/count';

  // Admin
  static const String adminStats = '$base/admin/stats';
  static const String adminStatsDocuments = '$adminStats/documents/total';
  static const String adminStatsSystem = '$adminStats/system';
}

/// =================================================
/// REVIEW / REACTION
/// =================================================
class ReviewEndpoints {
  static const String base = 'reviews';
  
  static const String documentStats = '$base/document'; // Append /$id/stats
  static const String documentReact = '$base/document'; // Append /$id/react

  // Admin stats
  static const String adminStats = '$base/admin/stats';
  static const String adminTotalLikes = '$adminStats/reactions/total-likes';
  static const String adminTotalReviews = '$adminStats/reviews/total';

  // Document related
  static const String documentStats = '$base/document'; // /{id}/stats
  static const String documentReact = '$base/document'; // /{id}/react

  // ✅ ADD — USER REACTION COUNT
  // GET /api/v1/reviews/user/me/reactions/count?type=LIKE
  static const String myReactionCount =
      '$base/user/me/reactions/count';

  // ✅ ADD — USER REVIEW COUNT
  // GET /api/v1/reviews/user/{userId}/count
  static const String userReviewCount =
      '$base/user/{{userId}}/count';
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