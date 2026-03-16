import 'package:studydocs/core/widgets/feat/document/upload_form/domain/entity/school.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/domain/repository/upload_repository.dart';

abstract interface class GetSchoolListUseCase {
  Future<List<School>> call();
}

class GetSchoolListUseCaseImpl implements GetSchoolListUseCase {
  final UploadRepository _repository;

  GetSchoolListUseCaseImpl(this._repository);

  @override
  Future<List<School>> call() {
    return _repository.getSchools();
  }
}

