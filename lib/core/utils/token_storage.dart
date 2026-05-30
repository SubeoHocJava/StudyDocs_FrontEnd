abstract class ITokenStorage {
  Future<void> saveTokens({required String accessToken, required String refreshToken});
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clearTokens();
}

// TODO: Implement this class using flutter_secure_storage or shared_preferences
// class TokenStorageImpl implements ITokenStorage { ... }
