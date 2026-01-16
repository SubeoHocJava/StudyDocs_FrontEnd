import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/data/datasource/asset_remote_datasource.dart';
import 'package:studydocs/data/model/api_response.dart';

import '../../core/constants/api_constants.dart';
import '../model/auth/request/register_request.dart';
import '../model/auth/request/update_user_request.dart';

abstract interface class UserRemoteDataSource {
  Future<ApiResponse> getThisUser();
  Future<ApiResponse> registerUser(RegisterRequest request, {String? traceId});
  Future<ApiResponse> updateUser(UpdateUserRequest request, {String? traceId});
  Future<ApiResponse> getUserById(String id, {String? traceId});
  Future<ApiResponse> isUserPrivate(String id, {String? traceId});
  Future<ApiResponse> isUserExists(String id, {String? traceId});
  Future<ApiResponse> uploadImage(String id, dynamic file, {String? traceId});
  Future<ApiResponse> getAllUsers({String? traceId});
  Future<ApiResponse> getUserCount({String? traceId});
  Future<ApiResponse> deleteUser(String id, {String? traceId});
  Future<ApiResponse> getUsersInRange(
    int fromIndex,
    int toIndex, {
    String? traceId,
  });
}