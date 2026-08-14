
import '../../../../../../../data/datasource/impl/user_datasource_impl.dart';
import '../../../../../../../data/datasource/user_remote_datasource.dart';
import '../../domain/entities/statistic_entity.dart';
import '../../domain/repositories/statistic_repository.dart';

class MockStatisticRepositoryImpl implements StatisticRepository {
  final UserDataSource userDataSource;

  MockStatisticRepositoryImpl({UserDataSource? dataSource})
      : userDataSource = dataSource ?? UserDatasourceImpl();

  @override
  Future<StatisticEntity> getStatisticData() async {
    final user = await userDataSource.getUser();
    return StatisticEntity(
      totalDocuments: user.postsCount,
      totalLikes: user.likesCount,
      totalComments: user.commentsCount,
    );
  }
}
