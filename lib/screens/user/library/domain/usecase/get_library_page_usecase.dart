import 'package:studydocs/screens/user/library/domain/entity/library_page_data.dart';
import 'package:studydocs/screens/user/library/domain/repository/library_repository.dart';

abstract interface class GetLibraryPageUseCase {
  Future<LibraryPageData> call();
}

class GetLibraryPageUseCaseImpl implements GetLibraryPageUseCase {
  final LibraryRepository _repository;

  const GetLibraryPageUseCaseImpl(this._repository);

  @override
  Future<LibraryPageData> call() {
    return _repository.getLibraryPage();
  }
}
