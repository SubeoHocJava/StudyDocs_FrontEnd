import '../../../../../../data/datasource/impl/user_datasource_impl.dart';
import '../../../../../../data/datasource/user_remote_datasource.dart';
import '../model/menu_profile.dart';

abstract class MenuProfileRepository {
  Future<MenuProfile> getMenuProfile(String userId);
}

class MenuProfileRepositoryImpl implements MenuProfileRepository {
  final UserDataSource userDataSource;

  MenuProfileRepositoryImpl({UserDataSource? dataSource}) 
      : userDataSource = dataSource ?? UserDatasourceImpl();

  @override
  Future<MenuProfile> getMenuProfile(String userId) async {
    final user = await userDataSource.getUser();
    return MenuProfile(
      userId: user.id ?? userId,
      userName: user.username ?? 'Unknown',
      fullName: user.fullName ?? user.username ?? 'Unknown',
      avatarUrl: user.avatarUrl,
      school: user.school,
      numMyUpload: user.postsCount,
      numMyLikes: user.likesCount,
      numMyComment: user.commentsCount,
    );
  }
}
