import '../../../../../data/datasource/statistic_remote_datasource.dart';
import '../../entity/statistic_entity.dart';
import '../statistic_repository.dart';

class StatisticRepositoryImpl implements StatisticRepository {
  final StatisticRemoteDataSource remoteDataSource;

  StatisticRepositoryImpl({required this.remoteDataSource});

  @override
  Future<StatisticEntity> getStatistics() async {
    try {
      final results = await Future.wait([
        remoteDataSource.getTotalDocuments(),
        remoteDataSource.getSystemStats('day'),
        remoteDataSource.getSystemStats('month'),
        remoteDataSource.getSystemStats('year'),
      ]);

      return StatisticEntity(
        totalDocuments: results[0],
        dayCount: results[1],
        monthCount: results[2],
        yearCount: results[3],
        totalLikes: 0, // Mock as per request
        totalComments: 0, // Mock as per request
      );
    } catch (e) {
      throw Exception('Failed to load statistics: $e');
    }
  }
}

