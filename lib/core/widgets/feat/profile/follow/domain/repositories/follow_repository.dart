
import 'package:studydocs/data/datasource/user_remote_datasource.dart';
import 'package:studydocs/data/datasource/impl/user_remote_datasource_impl.dart';
import '../models/follow_entity.dart';

abstract class FollowRepository {
  Future<FollowEntity> getFollowData();
}

class FollowRepositoryImpl implements FollowRepository {
  final UserRemoteDataSource userDataSource;

  FollowRepositoryImpl({UserRemoteDataSource? dataSource}) 
      : userDataSource = dataSource ?? UserRemoteDataSourceImpl();

  @override
  Future<FollowEntity> getFollowData() async {
    final user = await userDataSource.getUser();
    return FollowEntity(
      numFollowMe: user.followersCount, 
      numMeFollow: user.followingCount
    );
  }
}
