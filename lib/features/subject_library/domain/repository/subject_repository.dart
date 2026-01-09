import '../entity/subject_entity.dart';

/// Repository interface cho subject
/// Tầng domain không biết implementation cụ thể
abstract class SubjectRepository {
  /// Lấy danh sách môn học theo tên trường
  Future<List<SubjectEntity>> getSubjectsBySchool(String schoolName);
}
