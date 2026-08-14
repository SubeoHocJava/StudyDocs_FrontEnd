import 'dart:async';
import 'package:file_picker/file_picker.dart';

import '../../../../../../../../data/datasource/impl/user_datasource_impl.dart';
import '../../../../../../../../data/datasource/user_remote_datasource.dart';
import '../../model/user_infor_model.dart';
import '../infor_user_repository.dart';


import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/core/network/media_service.dart';
import 'package:studydocs/core/network/token_services.dart';
import 'package:studydocs/core/constants/api/user_api.dart';

class InforUserRepositoryImpl implements InforUserRepository {
  final UserDataSource userDataSource;

  InforUserRepositoryImpl({UserDataSource? dataSource}) 
      : userDataSource = dataSource ?? UserDatasourceImpl();

  @override
  Future<UserInforModel> getUserInfor(String userId) async {
    final user = await userDataSource.getUser();
    return UserInforModel(
      id: user.id ?? "",
      fullName: user.fullName ?? user.username ?? "",
      school: user.school,
      avatarUrl: user.avatarUrl,
      isFollowing: false, // Wait, user object doesn't have isFollowing right now
      isOwnProfile: userId == "me", // Assuming we fetched "me"
    );
  }

  @override
  Future<String> updateAvatar(PlatformFile file) async {
    final dioClient = DioClient();
    final mediaService = MediaService(dioClient);
    final tokenService = TokenStorageService();
    
    final userId = await tokenService.getUserId();
    if (userId == null) throw Exception("User not logged in");
    
    final mediaId = await mediaService.uploadMedia(
      file: file,
      ownerId: userId,
      ownerType: 'USER',
      mediaType: 'IMAGE',
    );
    
    if (mediaId == null) throw Exception("MediaService returned null mediaId!");
    
    final response = await dioClient.patch(
      UserEndpoints.updateImage(userId),
      data: {
        'avatarId': mediaId,
        'avatarUrl': '' 
      },
    );
    
    if (!response.isSuccess) {
      throw Exception("Failed to update avatar in user service");
    }
    
    final data = response.data;
    if (data != null && data['avatarUrl'] != null) {
      return data['avatarUrl'];
    }
    
    throw Exception("Failed to retrieve new avatar URL");
  }

  @override
  Future<bool> followUser(String userId) async {
    final dioClient = DioClient();
    final response = await dioClient.post('${UserEndpoints.base}/$userId/follow');
    return response.isSuccess;
  }

  @override
  Future<bool> unfollowUser(String userId) async {
    final dioClient = DioClient();
    final response = await dioClient.delete('${UserEndpoints.base}/$userId/follow');
    return response.isSuccess;
  }
}