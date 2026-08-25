
import 'package:studydocs/data/datasource/user_remote_datasource.dart';
import 'package:studydocs/data/datasource/impl/user_remote_datasource_impl.dart';
import 'package:studydocs/data/model/user/User.dart';
import '../model/menu_profile.dart';

abstract class MenuProfileRepository {
  Future<MenuProfile> getMenuProfile(String userId);
}

class MenuProfileRepositoryImpl implements MenuProfileRepository {
  final UserRemoteDataSource userDataSource;

  MenuProfileRepositoryImpl({UserRemoteDataSource? dataSource}) 
      : userDataSource = dataSource ?? UserRemoteDataSourceImpl();

  @override
  Future<MenuProfile> getMenuProfile(String userId) async {
    final userData = await userDataSource.getUser();
    final user = User.fromJson(userData as Map<String, dynamic>);
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
