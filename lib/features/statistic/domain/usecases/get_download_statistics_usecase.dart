import '../entity/download_statistic_entity.dart';
import '../repositories/statistic_repository.dart';

/// UseCase for getting download statistics
/// Encapsulates business logic for retrieving statistics data
class GetDownloadStatisticsUseCase {
  final StatisticRepository repository;

  GetDownloadStatisticsUseCase({required this.repository});

  /// Execute the use case
  /// Returns list of download statistics for the last 5 days
  Future<List<DownloadStatisticEntity>> call() async {
    return await repository.getDownloadStatistics();
  }
}
