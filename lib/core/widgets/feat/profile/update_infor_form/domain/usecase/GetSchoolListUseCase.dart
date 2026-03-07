import '../repository/UpdateInforRepository.dart';

class GetSchoolListUseCase {
  final UpdateInforRepository repository;

  GetSchoolListUseCase(this.repository);

  Future<List<String>> call() {
    return repository.getSchoolList();
  }
}