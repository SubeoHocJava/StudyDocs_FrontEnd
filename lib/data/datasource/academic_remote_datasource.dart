abstract interface class AcademicRemoteDataSource {
  Future<dynamic> getUniversities({int? limit, String? search});
  Future<dynamic> getUniversityById(String id);
  Future<dynamic> getFacultiesByUniversity(String universityId);
  Future<dynamic> getDepartmentsByFaculty(String facultyId);
  Future<dynamic> getSubjects({int? departmentId});
  Future<dynamic> getSubjectsByDepartment(String departmentId);
  Future<dynamic> getPublicUniversityById(String id);
  Future<dynamic> getPublicSubjectById(String id);
  Future<dynamic> getAcademicDocuments({String? query});
  Future<dynamic> createUniversity(Map<String, dynamic> request);
  Future<dynamic> createSubject(Map<String, dynamic> request);
  Future<dynamic> createSubjectForDepartment(String departmentId, Map<String, dynamic> request);
}
