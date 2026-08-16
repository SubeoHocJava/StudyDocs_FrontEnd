abstract interface class UserRemoteDataSource {
  Future<dynamic> getUser();
  Future<dynamic> updateUser(Map<String, dynamic> data);
}