abstract interface class AuthRemoteDataSource {
  Future<dynamic> login(String username, String password);
  Future<dynamic> register(Map<String, dynamic> data);
  Future<dynamic> verifyOtp(String email, String otp);
  Future<dynamic> refreshToken(String token);
  Future<dynamic> logout();
  Future<dynamic> completeGoogleLoginWithIdToken(String idToken);
  Future<dynamic> forgotPassword(String email);
  Future<dynamic> verifyResetToken(String email, String token);
  Future<dynamic> resetPassword(String email, String token, String newPassword);
}
