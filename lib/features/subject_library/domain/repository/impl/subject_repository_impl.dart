import '../../../../../data/datasource/subject_remote_datasource.dart';
import '../../../../../data/datasource/subject_remote_datasource_impl.dart';
import '../../entity/subject_entity.dart';
import '../subject_repository.dart';

/// Implement cụ thể của [SubjectRepository] sử dụng [SubjectRemoteDataSource].
/// Tầng này có nhiệm vụ:
/// - Gọi datasource
/// - Xử lý map dữ liệu nếu cần
/// - Bọc và chuẩn hoá lỗi (nếu muốn)
class SubjectRepositoryImpl implements SubjectRepository {
  final SubjectRemoteDataSource remote;

  SubjectRepositoryImpl({SubjectRemoteDataSource? remote})
    : remote = remote ?? SubjectRemoteDataSourceImpl();

  @override
  Future<List<SubjectEntity>> getSubjectsBySchool(String schoolName) {
    return remote.getSubjectsBySchool(schoolName);
  }

  @override
  Future<List<String>> getSchools() {
    return remote.getSchools();
  }
}
