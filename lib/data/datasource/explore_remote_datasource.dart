import 'package:studydocs/features/explore/domain/entity/school_entity.dart';

/// DataSource mock cho phần Khám phá.
/// Hiện tại dữ liệu được lưu ngay trong code để bạn dễ test UI.
class ExploreRemoteDataSource {
  final List<SchoolEntity> _schools = const [
    SchoolEntity(
      id: 'nlu',
      name: 'Trường Đại học Nông Lâm Tp. HCM',
      shortName: 'ĐH Nông Lâm',
    ),
    SchoolEntity(
      id: 'hcmut',
      name: 'Trường Đại học Bách Khoa Tp. HCM',
      shortName: 'ĐH Bách Khoa',
    ),
    SchoolEntity(
      id: 'hcmus',
      name: 'Trường Đại học Khoa học Tự nhiên',
      shortName: 'ĐH KHTN',
    ),
    SchoolEntity(
      id: 'uit',
      name: 'Trường Đại học Công nghệ Thông tin',
      shortName: 'ĐH CNTT',
    ),
  ];

  /// Trường hiện tại của user (mock: luôn là ĐH Nông Lâm, có thể null sau này).
  Future<SchoolEntity?> getCurrentUserSchool() async {
    // Giả lập delay hơi nhẹ để giống gọi API.
    await Future.delayed(const Duration(milliseconds: 200));
    return _schools.first;
  }

  /// Tìm kiếm trường theo tên.
  Future<List<SchoolEntity>> searchSchools(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (query.trim().isEmpty) return [];
    final lower = query.toLowerCase();
    return _schools
        .where((s) => s.name.toLowerCase().contains(lower))
        .toList();
  }
}


