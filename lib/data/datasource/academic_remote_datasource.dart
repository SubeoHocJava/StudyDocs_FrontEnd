import 'package:studydocs/features/explore/domain/entity/school_entity.dart';
import 'package:studydocs/features/subject_library/domain/entity/subject_entity.dart';

abstract class AcademicRemoteDataSource {
  // School/University operations
  Future<List<SchoolEntity>> searchSchools(String query);
  Future<List<String>> getSchools();
  Future<SchoolEntity?> getCurrentUserSchool();
  Future<SchoolEntity> getUniversityById(String id);  //  New

  // Subject operations
  Future<List<SubjectEntity>> getSubjectsBySchool(String schoolId);
  Future<SubjectEntity> getSubjectById(String id);    //  New
  Future<List<String>> getDocumentIds({String? universityId, String? subjectId});
}
