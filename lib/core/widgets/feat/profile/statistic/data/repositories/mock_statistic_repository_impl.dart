import '../../domain/entities/statistic_entity.dart';
import '../../domain/repositories/statistic_repository.dart';

class MockStatisticRepositoryImpl implements StatisticRepository {
  @override
  Future<StatisticEntity> getStatisticData() async {
    // Giả lập thời gian delay khi gọi API backend
    await Future.delayed(const Duration(seconds: 1));
    
    // Trả về dữ liệu mock
    return const StatisticEntity(
      totalDocuments: 15,
      totalLikes: 4,
      totalComments: 6,
    );
  }
}
