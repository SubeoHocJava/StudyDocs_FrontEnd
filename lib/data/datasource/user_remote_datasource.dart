import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:studydocs/core/network/dio_client.dart';
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
  Future<ApiResponse> getUsersInRange(int fromIndex, int toIndex, {String? traceId});
}

class UserDataSourceImpl implements UserRemoteDataSource {
  static UserDataSourceImpl? _instance;

  final DioClient dioClient;

  /// Private constructor
  UserDataSourceImpl._({required this.dioClient});

  /// Singleton factory
  factory UserDataSourceImpl({required DioClient dioClient}) {
    return _instance ??= UserDataSourceImpl._(dioClient: dioClient);
  }

  @override
  Future<ApiResponse> registerUser(RegisterRequest request, {String? traceId}) {
    return dioClient.post(
      ApiConstants.usersRegister,
      data: request.toJson(),
    );
  }

  @override
  Future<ApiResponse> updateUser(UpdateUserRequest request, {String? traceId}) {
    return dioClient.patch(
      ApiConstants.usersUpdate,
      data: request.toJson(),
    );
  }

  @override
  Future<ApiResponse> getUserById(String id, {String? traceId}) {
    return dioClient.get(
      ApiConstants.usersGetById,
      queryParameters: {'id': id},
    );
  }

  @override
  Future<ApiResponse> isUserPrivate(String id, {String? traceId}) {
    return dioClient.get(
      ApiConstants.usersIsPrivate,
      queryParameters: {'id': id},
    );
  }

  @override
  Future<ApiResponse> isUserExists(String id, {String? traceId}) {
    return dioClient.get(
      ApiConstants.usersExists,
      queryParameters: {'id': id},
    );
  }

  @override
  Future<ApiResponse> uploadImage(String id, dynamic file, {String? traceId}) async {
    FormData formData;

    if (file is PlatformFile) {
      // Check if running on web (bytes) or mobile (path)
      if (file.bytes != null) {
         formData = FormData.fromMap({
          "file": MultipartFile.fromBytes(
            file.bytes!,
            filename: file.name,
          ),
        });
      } else if (file.path != null) {
        formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(
            file.path!,
            filename: file.name,
          ),
        });
      } else {
         throw Exception("File is invalid (no bytes or path)");
      }
    } else {
       // Fallback or other file types if necessary
       throw Exception("Unsupported file type: ${file.runtimeType}");
    }

    return dioClient.post(
      ApiConstants.usersUpdateImage,
      queryParameters: {'id': id},
      data: formData,
    );
  }

  @override
  Future<ApiResponse> getAllUsers({String? traceId}) {
    return dioClient.get(ApiConstants.usersAll);
  }

  @override
  Future<ApiResponse> getUserCount({String? traceId}) {
    return dioClient.get(ApiConstants.usersCount);
  }

  @override
  Future<ApiResponse> deleteUser(String id, {String? traceId}) {
    return dioClient.delete(
      ApiConstants.usersDelete,
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
      ApiConstants.usersAll,
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

}
