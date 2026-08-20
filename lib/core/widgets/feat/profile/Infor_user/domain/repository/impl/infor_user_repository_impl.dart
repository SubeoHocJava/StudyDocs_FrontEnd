import 'dart:async';
import 'package:file_picker/file_picker.dart';

import '../../../../../../../../data/datasource/user_remote_datasource.dart';
import '../../../../../../../../data/datasource/impl/user_remote_datasource_impl.dart';
import '../../../../../../../../data/datasource/follow_remote_datasource.dart';
import '../../../../../../../../data/datasource/impl/follow_remote_datasource_impl.dart';
import '../../model/user_infor_model.dart';
import '../infor_user_repository.dart';

import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/core/network/media_service.dart';
import 'package:studydocs/core/network/token_services.dart';

class InforUserRepositoryImpl implements InforUserRepository {
  final UserRemoteDataSource userDataSource;
  final FollowRemoteDataSource followDataSource;

  InforUserRepositoryImpl({UserRemoteDataSource? userDs, FollowRemoteDataSource? followDs}) 
      : userDataSource = userDs ?? UserRemoteDataSourceImpl(),
        followDataSource = followDs ?? FollowRemoteDataSourceImpl();

  @override
  Future<UserInforModel> getUserInfor(String userId) async {
    final user = await userDataSource.getUser();
    return UserInforModel(
      id: user['id'] ?? "",
      fullName: user['fullName'] ?? user['username'] ?? "",
      school: user['school'],
      avatarUrl: user['avatarUrl'],
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
    
    
    final updatedUser = await userDataSource.updateUser(null, {
      'avatarId': mediaId,
      'avatarUrl': '' 
    });
    
    if (updatedUser != null && updatedUser['avatarUrl'] != null) {
      return updatedUser['avatarUrl'];
    }
    
    throw Exception("Failed to retrieve new avatar URL");
  }

  @override
  Future<bool> followUser(String userId) async {
    try {
      await followDataSource.followUser(userId);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> unfollowUser(String userId) async {
    try {
      await followDataSource.unfollowUser(userId);
      return true;
    } catch (_) {
      return false;
    }
  }
}