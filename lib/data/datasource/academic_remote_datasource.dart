import 'package:studydocs/features/explore/domain/entity/school_entity.dart';
import 'package:studydocs/features/subject_library/domain/entity/subject_entity.dart';

abstract class AcademicRemoteDataSource {
  // Explore logic (Schools/Universities)
  Future<SchoolEntity?> getCurrentUserSchool();
  Future<List<SchoolEntity>> searchSchools(String query);

  // Subject logic
  Future<List<SubjectEntity>> getSubjectsBySchool(String schoolName);
  Future<List<String>> getSchools();
}
