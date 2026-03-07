import '../models/follow_entity.dart';

abstract class FollowRepository {
  Future<FollowEntity> getFollowData();
}

class FollowRepositoryImpl implements FollowRepository {
  @override
  Future<FollowEntity> getFollowData() async {
    // Tạm thời tạo dữ liệu mẫu
    await Future.delayed(const Duration(milliseconds: 500));
    return const FollowEntity(numFollowMe: 154, numMeFollow: 42);
  }
}
