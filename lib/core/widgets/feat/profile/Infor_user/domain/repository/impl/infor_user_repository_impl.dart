import 'dart:async';
import 'package:file_picker/file_picker.dart';

import '../../model/user_infor_model.dart';

import '../infor_user_repository.dart';


import 'package:studydocs/core/network/dio_client.dart';
import 'package:studydocs/core/network/media_service.dart';
import 'package:studydocs/core/network/token_services.dart';
import 'package:studydocs/core/constants/api/user_api.dart';

class InforUserRepositoryImpl implements InforUserRepository {
  /// Mock database
  Map<String, UserInforModel> fakeDB = {
    "123": UserInforModel(
      id: "123",
      fullName: "Nguyễn Văn A",
      school: "Đại học Công nghệ",
      avatarUrl: "assets/icons/avt.png",
      isFollowing: false,
      isOwnProfile: false,
    ),
    "me": UserInforModel(
      id: "me",
      fullName: "Tôi",
      school: "ĐH Khoa học",
      avatarUrl: "assets/icons/avt.png",
      isFollowing: false,
      isOwnProfile: true,
    ),
  };

  @override
  Future<UserInforModel> getUserInfor(String userId) async {
    // await Future.delayed(const Duration(milliseconds: 300));
    return fakeDB[userId] ?? fakeDB["me"]!;
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
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Future<bool> unfollowUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }
}