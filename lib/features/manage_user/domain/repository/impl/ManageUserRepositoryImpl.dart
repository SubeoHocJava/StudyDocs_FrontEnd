import 'dart:async';

import 'package:studydocs/core/network/dio_client.dart';
import '../../../../../data/datasource/impl/asset_remote_datasource_impl.dart';
import '../../../../../data/datasource/impl/user_remote_datasource_impl.dart';
import '../../../../../data/model/auth/request/update_user_request.dart';

import '../../../../../data/model/user.dart';
import '../manage_user_repository.dart';


class ManageUserRepositoryImpl extends ManageUserRepository {
  late final UserDataSourceImpl userDataSource;

  /// Constructor rỗng
  ManageUserRepositoryImpl() {
    final dioClient = DioClient();
    userDataSource = UserDataSourceImpl(
      dioClient: dioClient,
        assetRemoteDataSource: AssetRemoteDataSourceImpl(dioClient: dioClient)
    );
  }

  // =============================
  // Add user (theo userID)
  // =============================
  @override
  Future<bool> addUser(String userID) async {
    try {
      // Kiểm tra xem user đã tồn tại chưa
      final existsResponse = await userDataSource.isUserExists(userID);
      
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
      final response = await userDataSource.deleteUser(userID);
      
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
    if (user.id.isEmpty) {
      return false;
    }

    try {
      final updateRequest = UpdateUserRequest(
        id: user.id,
        username: user.username,
        email: user.email,
        fullName: user.fullName,
        phoneNumber: user.phoneNumber,
        gender: user.gender,
        dateOfBirth: user.dateOfBirth,
        address: user.address,
        school: user.school,
      );

      final response = await userDataSource.updateUserByAdmin(updateRequest);
      
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
      final response = await userDataSource.getAllUsers();
      
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
      final response = await userDataSource.getUsersInRange(frompage, topage);
      
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
