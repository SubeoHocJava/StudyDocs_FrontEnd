import 'package:studydocs/core/widgets/feat/document/overview/domain/repository/library_repository.dart';

abstract interface class UnSaveUseCase {
  Future<void> call(String id);
}

class UnSaveUseCaseImpl implements UnSaveUseCase {
  final LibraryRepository _libraryRepository;

  UnSaveUseCaseImpl(this._libraryRepository);

  @override
  Future<void> call(String id) async {
    return await _libraryRepository.unsave(id);
  }
}
