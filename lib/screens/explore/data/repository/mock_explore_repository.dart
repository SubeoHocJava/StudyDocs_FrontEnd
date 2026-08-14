import '../../domain/entity/explore_model.dart';
import '../../domain/repository/explore_repository.dart';

class MockExploreRepository implements ExploreRepository {
  @override
  Future<ExploreModel> getExploreData() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return const ExploreModel(
      universityName: 'Trường Đại học Nông Lâm Tp. HCM',
      hintText: 'Tìm kiếm trong Trường Đại học Nông Lâm...',
    );
  }
}
