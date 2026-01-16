
abstract class StatisticRemoteDataSource {
  Future<int> getTotalDocuments();
  Future<int> getSystemStats(String period);
}
