import '../../features/subject_library/domain/entity/subject_entity.dart';

/// Contract cho datasource subject
/// UI / Bloc / Repository KHÔNG biết implementation cụ thể
abstract class SubjectRemoteDataSource {
  /// Lấy danh sách môn học theo tên trường
  Future<List<SubjectEntity>> getSubjectsBySchool(String schoolName);

  /// Lấy danh sách tên các trường có trong datasource
  Future<List<String>> getSchools();
}
