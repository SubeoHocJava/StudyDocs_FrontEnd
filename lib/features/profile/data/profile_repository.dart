class ProfileRepository {
  Future<Map<String, dynamic>> getProfile(int userId) async {
    // TODO: gọi API thật
    await Future.delayed(const Duration(seconds: 1));
    return {
      "id": userId,
      "name": "Nguyễn Văn A",
      "email": "vana@example.com",
    };
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    // TODO: gọi API update
    await Future.delayed(const Duration(seconds: 1));
    return data;
  }
}
