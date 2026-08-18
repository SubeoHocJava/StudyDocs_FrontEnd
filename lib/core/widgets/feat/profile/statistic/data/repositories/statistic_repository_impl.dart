import '../../domain/repositories/statistic_repository.dart';
import '../../domain/entities/statistic_entity.dart';

class StatisticRepositoryImpl implements StatisticRepository {
  @override
  Future<StatisticEntity> getStatisticData() async {
    // TODO: Implement actual API call
    return const StatisticEntity(
      totalDocuments: 0,
      totalLikes: 0,
      totalComments: 0,
    );
  }
}
