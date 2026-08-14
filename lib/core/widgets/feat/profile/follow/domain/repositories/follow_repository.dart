
import '../../../../../../../data/datasource/impl/user_datasource_impl.dart';
import '../../../../../../../data/datasource/user_remote_datasource.dart';
import '../models/follow_entity.dart';

abstract class FollowRepository {
  Future<FollowEntity> getFollowData();
}

class FollowRepositoryImpl implements FollowRepository {
  final UserDataSource userDataSource;

  FollowRepositoryImpl({UserDataSource? dataSource}) 
      : userDataSource = dataSource ?? UserDatasourceImpl();

  @override
  Future<FollowEntity> getFollowData() async {
    final user = await userDataSource.getUser();
    return FollowEntity(
      numFollowMe: user.followersCount, 
      numMeFollow: user.followingCount
    );
  }
}
