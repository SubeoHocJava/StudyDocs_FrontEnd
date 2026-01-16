import '../entity/statistic_entity.dart';
import '../repositories/statistic_repository.dart';

class GetStatisticsUseCase {
  final StatisticRepository repository;

  GetStatisticsUseCase({required this.repository});

  Future<StatisticEntity> call() async {
    return await repository.getStatistics();
  }
}

