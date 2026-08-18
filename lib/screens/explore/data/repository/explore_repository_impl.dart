import '../../domain/repository/explore_repository.dart';
import '../../domain/entity/explore_model.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  @override
  Future<ExploreModel> getExploreData() async {
    // TODO: Implement actual API call
    return const ExploreModel(
      universityName: '',
      hintText: '',
    );
  }
}
