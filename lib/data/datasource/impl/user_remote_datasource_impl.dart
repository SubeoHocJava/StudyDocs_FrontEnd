import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:studydocs/core/constants/api_constants.dart';
import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/data/datasource/asset_remote_datasource.dart';
import 'package:studydocs/data/datasource/user_remote_datasource.dart';
import 'package:studydocs/data/model/auth/request/register_request.dart';
import 'package:studydocs/data/model/auth/request/update_user_request.dart';

import '../../model/api_response.dart';

class UserDataSourceImpl implements UserRemoteDataSource {
  static UserDataSourceImpl? _instance;
  final DioClient dioClient;
  final AssetRemoteDataSource assetRemoteDataSource;

  /// Private constructor
  UserDataSourceImpl._({
    required this.dioClient,
    required this.assetRemoteDataSource,
  });

  /// Singleton factory
  factory UserDataSourceImpl({
    required DioClient dioClient,
    required AssetRemoteDataSource assetRemoteDataSource,
  }) {
    return _instance ??= UserDataSourceImpl._(
      dioClient: dioClient,
      assetRemoteDataSource: assetRemoteDataSource,
    );
  }

  @override
  Future<ApiResponse> registerUser(RegisterRequest request, {String? traceId}) {
    return dioClient.post(UserEndpoints.register, data: request.toJson());
  }

  @override
  Future<ApiResponse> updateUser(UpdateUserRequest request, {String? traceId}) {
    return dioClient.patch(
      UserEndpoints.update,
      data: request.toJson(),
      queryParameters: request.id != null ? {'id': request.id} : null,
    );
  }

  @override
  Future<ApiResponse> getUserById(String id, {String? traceId}) async {
    final response = await dioClient.get(
      UserEndpoints.getById,
      queryParameters: {'id': id},
    );

    if (response.isSuccess && response.data != null) {
      final userData = response.data as Map<String, dynamic>;

      // Backend returns ID in 'avatarUrl' field mostly
      String? currentAvatar = userData['avatarUrl'] as String?;

      // Use 'avatarId' if available, otherwise check 'avatarUrl' (if it's not a URL)
      String? avatarId = userData['avatarId'] as String?;

      if (avatarId == null &&
          currentAvatar != null &&
          !currentAvatar.startsWith('http') &&
          !currentAvatar.startsWith('/')) {
        avatarId = currentAvatar;
      }

      if (avatarId != null && avatarId.isNotEmpty) {
        try {
          final asset = await assetRemoteDataSource.getAssetById(avatarId);
          if (asset.previewUrls.isNotEmpty) {
            userData['avatarUrl'] = asset.previewUrls.first;
          }
        } catch (e) {
          // Ignore asset fetch error to not block user fetch
          print("Failed to fetch avatar: $e");
        }
      }
    }

    return response;
  }

  @override
  Future<ApiResponse> isUserPrivate(String id, {String? traceId}) {
    return dioClient.get(
      UserEndpoints.isPrivate,
      queryParameters: {'id': id},
    );
  }

  @override
  Future<ApiResponse> isUserExists(String id, {String? traceId}) {
    return dioClient.get(UserEndpoints.exists, queryParameters: {'id': id});
  }

  @override
  Future<ApiResponse> uploadImage(
      String id,
      dynamic file, {
        String? traceId,
      }) async {
    FormData formData;

    if (file is PlatformFile) {
      // Check if running on web (bytes) or mobile (path)
      if (file.bytes != null) {
        formData = FormData.fromMap({
          "file": MultipartFile.fromBytes(file.bytes!, filename: file.name),
        });
      } else if (file.path != null) {
        formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(file.path!, filename: file.name),
        });
      } else {
        throw Exception("File is invalid (no bytes or path)");
      }
    } else {
      // Fallback or other file types if necessary
      throw Exception("Unsupported file type: ${file.runtimeType}");
    }

    return dioClient.post(
      UserEndpoints.updateImage,
      queryParameters: {'id': id},
      data: formData,
    );
  }

  @override
  Future<ApiResponse> getAllUsers({String? traceId}) {
    return dioClient.get(UserEndpoints.all);
  }

  @override
  Future<ApiResponse> getUserCount({String? traceId}) {
    return dioClient.get(UserEndpoints.count);
  }

  @override
  Future<ApiResponse> deleteUser(String id, {String? traceId}) {
    return dioClient.delete(
      UserEndpoints.delete,
      queryParameters: {'id': id},
    );
  }

  @override
  Future<ApiResponse> getUsersInRange(
      int fromIndex,
      int toIndex, {
        String? traceId,
      }) {
    return dioClient.get(
      UserEndpoints.all,
      // queryParameters: {
      //   'fromIndex': fromIndex,
      //   'toIndex': toIndex,
      // },
    );
  }

  @override
  Future<ApiResponse<dynamic>> getThisUser() {
    // TODO: implement getThisUser
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse> saveDocument(String documentId, {String? traceId}) {
    return dioClient.post(
      UserEndpoints.documentSave,
      queryParameters: {'documentId': documentId},
    );
  }

  @override
  Future<ApiResponse> getSavedDocuments({String? traceId}) {
    return dioClient.get(UserEndpoints.documentSaved);
  }

  @override
  Future<ApiResponse> updateUserByAdmin(UpdateUserRequest request, {String? traceId}) {
    return dioClient.patch(
      UserEndpoints.updateUserByAdmin,
      data: request.toJson(),
      queryParameters: request.id != null ? {'id': request.id} : null,

  @override
  Future<ApiResponse> getMyDocumentCount({String? traceId}) {
    return dioClient.get(
      DocumentEndpoints.myDocumentCount,
    );
  }

  /// ===============================
  /// REVIEW / REACTION
  /// ===============================
  @override
  Future<ApiResponse> getMyReactionCount(
      String type, {
        String? traceId,
      }) {
    return dioClient.get(
      ReviewEndpoints.myReactionCount,
      queryParameters: {'type': type},
    );
  }

  @override
  Future<ApiResponse> getUserReviewCount(
      String userId, {
        String? traceId,
      }) {
    return dioClient.get(
      ReviewEndpoints.userReviewCount.replaceAll(
        '{{userId}}',
        userId,
      ),
    );
  }
}
