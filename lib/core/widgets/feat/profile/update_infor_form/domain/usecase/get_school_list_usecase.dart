import '../repository/update_infor_repository.dart';

class GetSchoolListUseCase {
  final UpdateInforRepository repository;

  GetSchoolListUseCase(this.repository);

  Future<List<String>> call() {
    return repository.getSchoolList();
  }
}
