/// User Service — business endpoints (cần Bearer token).
class UserEndpoints {
  UserEndpoints._();

  static const String base = 'user';

  static const String me = '$base/me';
  static const String all = base;

  static String byId(String userId) => '$base/public/profile/$userId';
  static String other(String userId) => '$base/$userId/other';
  static String update(String userId) => '$base/$userId';
  static String updateInfo(String userId) => '$base/$userId/info';
  static String updateImage(String userId) => '$base/$userId/image';
  static String delete(String userId) => '$base/$userId';
  static String search() => '$base/search';
  
  static const String requestUpdateEmail = '$base/me/update-email/request';
  static const String verifyUpdateEmail = '$base/me/update-email/verify';
}
