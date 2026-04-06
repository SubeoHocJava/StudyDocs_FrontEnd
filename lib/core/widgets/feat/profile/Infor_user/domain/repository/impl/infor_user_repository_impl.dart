import 'dart:async';
import 'package:file_picker/file_picker.dart';

import '../../model/user_infor_model.dart';

import '../infor_user_repository.dart';


class InforUserRepositoryMock implements InforUserRepository {
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
    return fakeDB[userId]!;
  }

  @override
  Future<String> updateAvatar(PlatformFile file) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return file.path!; // trả về local path
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