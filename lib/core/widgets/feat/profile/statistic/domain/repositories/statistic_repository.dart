import '../entities/statistic_entity.dart';

abstract class StatisticRepository {
  Future<StatisticEntity> getStatisticData();
}
