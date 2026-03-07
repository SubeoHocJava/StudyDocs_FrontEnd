import '../models/follow_entity.dart';
import '../repositories/follow_repository.dart';

class GetFollowDataUseCase {
  final FollowRepository repository;

  GetFollowDataUseCase(this.repository);

  Future<FollowEntity> call() async {
    return await repository.getFollowData();
  }
}
