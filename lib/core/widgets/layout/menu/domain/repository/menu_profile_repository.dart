import '../model/menu_profile.dart';

abstract class MenuProfileRepository {
  Future<MenuProfile> getMenuProfile(String userId);
}

class MenuProfileRepositoryImpl implements MenuProfileRepository {
  @override
  Future<MenuProfile> getMenuProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MenuProfile(
      userId: userId,
      userName: 'mockUser',
      fullName: 'Mock User',
      avatarUrl: null,
      school: 'Mock School',
      numMyUpload: 10,
      numMyLikes: 20,
      numMyComment: 5,
    );
  }
}
