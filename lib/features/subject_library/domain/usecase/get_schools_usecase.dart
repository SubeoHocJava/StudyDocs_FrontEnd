import '../repository/subject_repository.dart';

/// UseCase: Lấy danh sách tên các trường
class GetSchoolsUseCase {
  final SubjectRepository repository;

  GetSchoolsUseCase({required this.repository});

  Future<List<String>> call() {
    return repository.getSchools();
  }
}
