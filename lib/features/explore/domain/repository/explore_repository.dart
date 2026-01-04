import 'package:studydocs/features/explore/domain/entity/school_entity.dart';

/// Repository cho phần Khám phá (hiện tại chỉ cần mock danh sách trường).
abstract class ExploreRepository {
  Future<List<SchoolEntity>> searchSchools(String query);

  /// Trường hiện tại của user (nếu có), để hiển thị dòng "Trường Đại học ..."
  Future<SchoolEntity?> getCurrentUserSchool();
}


