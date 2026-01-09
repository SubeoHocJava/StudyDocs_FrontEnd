import '../entity/subject_entity.dart';
import '../repository/subject_repository.dart';

/// UseCase thể hiện 1 "hành động nghiệp vụ" cụ thể: lấy danh sách môn học theo trường.
/// BLoC sẽ chỉ làm việc với UseCase, không cần biết bên dưới là repository gì.
class GetSubjectsBySchoolUseCase {
  final SubjectRepository repository;

  GetSubjectsBySchoolUseCase({required this.repository});

  Future<List<SubjectEntity>> call(String schoolName) {
    return repository.getSubjectsBySchool(schoolName);
  }
}
