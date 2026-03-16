import 'package:studydocs/core/widgets/feat/document/upload_form/domain/repository/upload_repository.dart';

abstract interface class SubmitUploadUseCase {
  Future<void> call(UploadRequest request);
}

class SubmitUploadUseCaseImpl implements SubmitUploadUseCase {
  final UploadRepository _repository;

  SubmitUploadUseCaseImpl(this._repository);

  @override
  Future<void> call(UploadRequest request) {
    return _repository.submitUpload(request);
  }
}

