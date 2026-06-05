import 'package:studydocs/screens/user/library/domain/entity/library_subject_page_data.dart';
import 'package:studydocs/screens/user/library/domain/repository/library_repository.dart';

abstract interface class GetLibrarySubjectPageUseCase {
  Future<LibrarySubjectPageData> call(String subjectId);
}

class GetLibrarySubjectPageUseCaseImpl implements GetLibrarySubjectPageUseCase {
  final LibraryRepository _repository;

  const GetLibrarySubjectPageUseCaseImpl(this._repository);

  @override
  Future<LibrarySubjectPageData> call(String subjectId) {
    return _repository.getLibrarySubjectPage(subjectId);
  }
}
