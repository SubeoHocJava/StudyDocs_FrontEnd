import '../entity/statistic_entity.dart';

abstract class StatisticRepository {
  Future<StatisticEntity> getStatistics();
}

