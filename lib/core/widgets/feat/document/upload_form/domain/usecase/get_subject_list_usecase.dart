import 'package:studydocs/core/widgets/feat/document/upload_form/domain/entity/subject.dart';
import 'package:studydocs/core/widgets/feat/document/upload_form/domain/repository/upload_repository.dart';

abstract interface class GetSubjectListUseCase {
  Future<List<Subject>> call(String schoolId);
}

class GetSubjectListUseCaseImpl implements GetSubjectListUseCase {
  final UploadRepository _repository;

  GetSubjectListUseCaseImpl(this._repository);

  @override
  Future<List<Subject>> call(String schoolId) {
    return _repository.getSubjectsBySchool(schoolId);
  }
}

