import 'package:studydocs/data/model/api_response.dart';

import '../model/auth/request/register_request.dart';
import '../model/auth/request/update_user_request.dart';

abstract interface class UserRemoteDataSource {
  Future<ApiResponse> getThisUser();
  Future<ApiResponse> registerUser(RegisterRequest request, {String? traceId});
  Future<ApiResponse> updateUser(UpdateUserRequest request, {String? traceId});
  Future<ApiResponse> updateUserByAdmin(UpdateUserRequest request, {String? traceId});
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
  
  /// Save/Unsave document (toggle)
  /// Returns true if document is now saved, false if unsaved
  Future<ApiResponse> saveDocument(String documentId, {String? traceId});
  
  /// Get list of saved document IDs for current user
  Future<ApiResponse> getSavedDocuments({String? traceId});
}