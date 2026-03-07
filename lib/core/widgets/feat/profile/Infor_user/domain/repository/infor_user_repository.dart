import 'package:file_picker/file_picker.dart';

import '../model/user_infor_model.dart';

abstract class InforUserRepository {
  Future<UserInforModel> getUserInfor(String userId);

  Future<String> updateAvatar(PlatformFile file);

  Future<bool> followUser(String userId);

  Future<bool> unfollowUser(String userId);
}