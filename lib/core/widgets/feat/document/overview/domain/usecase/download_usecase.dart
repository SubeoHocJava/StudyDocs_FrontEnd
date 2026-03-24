import 'package:studydocs/core/widgets/feat/document/overview/domain/repository/document_repository.dart';

abstract interface class DownloadUseCase {
  Future<String> call(String id);
}

class DownloadUseCaseImpl implements DownloadUseCase {
  final DocumentRepository _documentRepository;

  DownloadUseCaseImpl(this._documentRepository);

  @override
  Future<String> call(String id) async {
    return await _documentRepository.download(id);
  }
}
