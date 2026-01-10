import '../../../../../data/datasource/statistic_remote_datasource.dart';
import '../../entity/download_statistic_entity.dart';
import '../statistic_repository.dart';

/// Implementation of StatisticRepository
/// Connects domain layer with data layer
class StatisticRepositoryImpl implements StatisticRepository {
  final StatisticRemoteDataSource remoteDataSource;

  StatisticRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<DownloadStatisticEntity>> getDownloadStatistics() async {
    try {
      // Call datasource to get raw data
      final rawData = await remoteDataSource.getDownloadStatistics();

      // Parse raw data to entities
      return rawData.map((json) {
        return DownloadStatisticEntity(
          date: DateTime.parse(json['date'] as String),
          count: json['count'] as int,
        );
      }).toList();
    } catch (e) {
      // In production, handle specific exceptions
      throw Exception('Failed to load download statistics: $e');
    }
  }
}
