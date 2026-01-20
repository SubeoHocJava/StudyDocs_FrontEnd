import '../repository/profile_repository.dart';

class GetSchoolsUseCase {
  final ProfileRepository repository;

  GetSchoolsUseCase(this.repository);

  Future<List<String>> call() {
    return repository.getSchools();
  }
}
