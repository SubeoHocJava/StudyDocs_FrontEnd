import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/core/constants/api/user_api.dart';
import '../user_remote_datasource.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient _client;

  UserRemoteDataSourceImpl({DioClient? client}) : _client = client ?? DioClient();

  @override
  Future<dynamic> getUser() async {
    final response = await _client.get(UserEndpoints.me);
    if (response.isSuccess && response.data != null) {
      return response.data;
    }
    throw Exception('Failed to load user profile');
  }

  @override
  Future<dynamic> getUserProfile(String userId) async {
    final response = await _client.get(UserEndpoints.byId(userId));
    if (response.isSuccess && response.data != null) {
      return response.data;
    }
    throw Exception('Failed to load user profile');
  }

  @override
  Future<dynamic> updateUser(String? userId, Map<String, dynamic> data) async {
    final endpoint = userId == null ? UserEndpoints.me : UserEndpoints.update(userId);
    final response = await _client.put(endpoint, data: data);
    if (response.isSuccess) {
      return response.data;
    }
    throw Exception('Failed to update user profile');
  }

  @override
  Future<dynamic> updateProfileImage(String userId, dynamic data) async {
    final response = await _client.post(UserEndpoints.updateImage(userId), data: data);
    if (response.isSuccess) {
      return response.data;
    }
    throw Exception('Failed to update profile image');
  }

  @override
  Future<dynamic> searchUsers(String query) async {
    final response = await _client.get(UserEndpoints.search(), queryParameters: {'q': query});
    if (response.isSuccess && response.data != null) {
      return response.data;
    }
    throw Exception('Failed to search users');
  }

  @override
  Future<void> deleteUser(String userId) async {
    final response = await _client.delete(UserEndpoints.delete(userId));
    if (!response.isSuccess) {
      throw Exception('Failed to delete user');
    }
  }

  @override
  Future<dynamic> requestUpdateEmail(String email) async {
    final response = await _client.post(UserEndpoints.requestUpdateEmail, data: {'email': email});
    if (response.isSuccess) {
      return response.data;
    }
    throw Exception('Failed to request update email');
  }

  @override
  Future<dynamic> verifyAndUpdateEmail(String token) async {
    final response = await _client.post(UserEndpoints.verifyUpdateEmail, data: {'token': token});
    if (response.isSuccess) {
      return response.data;
    }
    throw Exception('Failed to verify and update email');
  }
}
