abstract interface class AuthRemoteDataSource {
  Future<dynamic> login(String username, String password);
  Future<dynamic> register(Map<String, dynamic> data);
  Future<dynamic> verifyOtp(String email, String otp);
  Future<dynamic> refreshToken(String token);
  Future<dynamic> logout();
  Future<dynamic> startGoogleLogin(String codeChallenge, String codeChallengeMethod, String redirectUri);
  Future<dynamic> completeGoogleLogin(String code, String codeVerifier, String redirectUri);
}
