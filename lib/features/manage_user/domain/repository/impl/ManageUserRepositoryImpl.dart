import 'dart:async';

import 'package:studydocs/data/datasource/user_remote_datasource.dart';
import 'package:studydocs/data/model/auth/request/update_user_request.dart';
import 'package:studydocs/data/model/user.dart';
import '../../../../../core/network/dio_client.dart';
import '../manage_user_repository.dart';

class ManageUserRepositoryImpl extends ManageUserRepository {
  late final UserRemoteDataSource userRemoteDataSource;

  /// Constructor rỗng
  ManageUserRepositoryImpl() {
    userRemoteDataSource = UserDataSourceImpl(
      dioClient: DioClient(),
    );
  }

  // =============================
  // Add user (theo userID)
  // =============================
  @override
  Future<bool> addUser(String userID) async {
    try {
      // Kiểm tra xem user đã tồn tại chưa
      final existsResponse = await userRemoteDataSource.isUserExists(userID);
      
      if (existsResponse.statusCode == 200 && existsResponse.data == true) {
        return false; // User đã tồn tại
      }

      // Note: Nếu cần thêm user mới, bạn cần implement endpoint register
      // hoặc sử dụng endpoint khác phù hợp với backend
      return false;
    } catch (e) {
      print('Error adding user: $e');
      return false;
    }
  }

  // =============================
  // Delete user
  // =============================
  @override
  Future<bool> deleteUser(String userID) async {
    try {
      final response = await userRemoteDataSource.deleteUser(userID);
      
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

  // =============================
  // Edit user
  // =============================
  @override
  Future<bool> editUser(UserModel user) async {
    try {
      final updateRequest = UpdateUserRequest(
        id: user.id,
        fullName: user.fullName,
        phoneNumber: user.phoneNumber,
        gender: user.gender,
        dateOfBirth: user.dateOfBirth,
        address: user.address,
        school: user.school,
      );

      final response = await userRemoteDataSource.updateUser(updateRequest);
      
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error editing user: $e');
      return false;
    }
  }

  // =============================
  // Find user by username + paging
  // =============================
  @override
  Future<List<UserModel>> findUserPage(
    int frompage,
    int topage,
    String username,
  ) async {
    try {
      // Lấy tất cả users
      final response = await userRemoteDataSource.getAllUsers();
      
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> usersJson = response.data as List<dynamic>;
        final allUsers = usersJson
            .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
            .toList();

        // Filter theo username/fullName
        final filtered = allUsers.where((u) =>
          u.fullName.toLowerCase().contains(username.toLowerCase()) ||
          u.username.toLowerCase().contains(username.toLowerCase())
        ).toList();

        print('Searching for: $username');
        print('Found ${filtered.length} users');
        
        return filtered;
      }
      return [];
    } catch (e) {
      print('Error finding users: $e');
      return [];
    }
  }

  // =============================
  // Get user list by page
  // =============================
  @override
  Future<List<UserModel>> getListUserPage(
    int frompage,
    int topage,
    int numUser,
  ) async {
    try {
      // Sử dụng getUsersInRange từ datasource
      final response = await userRemoteDataSource.getUsersInRange(frompage, topage);
      
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> usersJson = response.data as List<dynamic>;
        final users = usersJson
            .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        return users;
      }
      return [];
    } catch (e) {
      print('Error getting user list: $e');
      return [];
    }
  }
}
