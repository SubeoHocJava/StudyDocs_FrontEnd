import '../entity/explore_model.dart';

abstract interface class ExploreRepository {
  Future<ExploreModel> getExploreData();
}
