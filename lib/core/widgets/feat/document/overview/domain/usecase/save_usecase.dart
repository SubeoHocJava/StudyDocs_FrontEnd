import 'package:studydocs/core/widgets/feat/document/overview/domain/repository/library_repository.dart';

abstract interface class SaveUseCase {
  Future<void> call(String id);
}

class SaveUseCaseImpl implements SaveUseCase {
  final LibraryRepository _libraryRepository;

  SaveUseCaseImpl(this._libraryRepository);

  @override
  Future<void> call(String id) async {
    return await _libraryRepository.save(id);
  }
}
