import 'package:studydocs/data/datasource/academic_remote_datasource.dart';
import 'package:studydocs/features/subject_library/domain/entity/subject_entity.dart';
import 'package:studydocs/features/subject_library/domain/repository/subject_repository.dart';

/// Implement cụ thể của [SubjectRepository] sử dụng [AcademicRemoteDataSource].
class SubjectRepositoryImpl implements SubjectRepository {
  final AcademicRemoteDataSource remote;

  SubjectRepositoryImpl({required this.remote});

  @override
  Future<List<SubjectEntity>> getSubjectsBySchool(String schoolName) {
    return remote.getSubjectsBySchool(schoolName);
  }

  @override
  Future<List<String>> getSchools() {
    return remote.getSchools();
  }
}
