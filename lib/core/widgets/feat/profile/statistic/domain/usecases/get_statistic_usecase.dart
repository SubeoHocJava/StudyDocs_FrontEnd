import '../repositories/statistic_repository.dart';
import '../entities/statistic_entity.dart';

class GetStatisticUseCase {
  final StatisticRepository repository;

  GetStatisticUseCase(this.repository);

  Future<StatisticEntity> call() async {
    return await repository.getStatisticData();
  }
}
