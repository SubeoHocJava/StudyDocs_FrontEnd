abstract interface class AcademicRemoteDataSource {
  Future<dynamic> getUniversities({int? limit, String? search});
  Future<dynamic> getUniversityById(String id);
  Future<dynamic> getFacultiesByUniversity(String universityId);
  Future<dynamic> getSubjects();
}
