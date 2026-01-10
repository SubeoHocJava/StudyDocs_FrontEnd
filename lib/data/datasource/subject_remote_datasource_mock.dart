import '../../features/subject_library/domain/entity/subject_entity.dart';
import 'subject_remote_datasource.dart';

/// Mock datasource cho subjects
/// Sau này có thể swap thành implementation gọi API thật
class SubjectRemoteDataSourceMock implements SubjectRemoteDataSource {
  /// Map school name → list subjects
  /// Mock data cho "Trường Đại học Nông Lâm Tp. HCM"
  final Map<String, List<SubjectEntity>> _schoolSubjects = {
    'Trường Đại học Nông Lâm Tp. HCM': const [
      SubjectEntity(id: 'sub_1', name: 'Công nghệ phần mềm'),
      SubjectEntity(id: 'sub_2', name: 'An toàn và bảo mật hệ thống thông tin'),
      SubjectEntity(id: 'sub_3', name: 'Lập trình .NET'),
      SubjectEntity(id: 'sub_4', name: 'Lập trình Front End'),
      SubjectEntity(id: 'sub_5', name: 'Machine Learning'),
    ],
    'Trường Đại học Bách Khoa Tp. HCM': const [
      SubjectEntity(id: 'bk_1', name: 'Cấu trúc dữ liệu và giải thuật'),
      SubjectEntity(id: 'bk_2', name: 'Hệ điều hành'),
      SubjectEntity(id: 'bk_3', name: 'Mạng máy tính'),
    ],
    'Trường Đại học Khoa học Tự nhiên': const [
      SubjectEntity(id: 'ktn_1', name: 'Toán cao cấp'),
      SubjectEntity(id: 'ktn_2', name: 'Vật lý đại cương'),
    ],
    'Trường Đại học Công nghệ Thông tin': const [
      SubjectEntity(id: 'uit_1', name: 'Lập trình Java'),
      SubjectEntity(id: 'uit_2', name: 'Cơ sở dữ liệu'),
      SubjectEntity(id: 'uit_3', name: 'Thiết kế web'),
    ],
  };

  @override
  Future<List<SubjectEntity>> getSubjectsBySchool(String schoolName) async {
    // Giả lập delay như gọi API
    await Future.delayed(const Duration(milliseconds: 300));

    // Tìm subjects theo school name (case-insensitive)
    final normalizedName = schoolName.trim();
    final subjects = _schoolSubjects[normalizedName];

    if (subjects != null) {
      return subjects;
    }

    // Nếu không tìm thấy exact match, tìm partial match
    for (final entry in _schoolSubjects.entries) {
      if (entry.key.toLowerCase().contains(normalizedName.toLowerCase()) ||
          normalizedName.toLowerCase().contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }

    // Default: trả về subjects của Nông Lâm
    return _schoolSubjects['Trường Đại học Nông Lâm Tp. HCM'] ?? [];
  }
}
