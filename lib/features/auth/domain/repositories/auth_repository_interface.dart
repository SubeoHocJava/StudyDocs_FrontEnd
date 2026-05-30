abstract class IAuthRepository {
  Future<void> login({required String username, required String password});
  Future<void> register({
    required String username,
    required String password,
    String? displayName,
  });
  Future<void> logout();
  Future<void> refreshToken();
  
  // You might want to return a User model or stream of AuthState depending on your architecture
}
