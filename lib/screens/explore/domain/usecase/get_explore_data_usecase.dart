import '../entity/explore_model.dart';
import '../repository/explore_repository.dart';

abstract interface class GetExploreDataUseCase {
  Future<ExploreModel> call();
}

class GetExploreDataUseCaseImpl implements GetExploreDataUseCase {
  final ExploreRepository _repository;

  GetExploreDataUseCaseImpl(this._repository);

  @override
  Future<ExploreModel> call() async {
    return await _repository.getExploreData();
  }
}
