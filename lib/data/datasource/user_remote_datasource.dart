abstract interface class UserRemoteDataSource {
  Future<dynamic> getUser();
  Future<dynamic> getUserProfile(String userId);
  Future<dynamic> updateUser(String? userId, Map<String, dynamic> data);
  Future<dynamic> updateProfileImage(String userId, dynamic data);
  Future<dynamic> searchUsers(String query);
  Future<void> deleteUser(String userId);
}