import '../entity/download_statistic_entity.dart';

/// Abstract repository for statistics operations
/// Following Clean Architecture principles
abstract class StatisticRepository {
  /// Get download statistics for the last 5 days
  /// Returns list of DownloadStatisticEntity
  /// Throws exception if data fetching fails
  Future<List<DownloadStatisticEntity>> getDownloadStatistics();
}
