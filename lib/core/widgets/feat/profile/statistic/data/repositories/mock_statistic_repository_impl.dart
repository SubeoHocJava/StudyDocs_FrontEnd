
import 'package:studydocs/data/datasource/user_remote_datasource.dart';
import 'package:studydocs/data/datasource/impl/user_remote_datasource_impl.dart';
import '../../domain/entities/statistic_entity.dart';
import '../../domain/repositories/statistic_repository.dart';

class MockStatisticRepositoryImpl implements StatisticRepository {
  final UserRemoteDataSource userDataSource;

  MockStatisticRepositoryImpl({UserRemoteDataSource? dataSource})
      : userDataSource = dataSource ?? UserRemoteDataSourceImpl();

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
