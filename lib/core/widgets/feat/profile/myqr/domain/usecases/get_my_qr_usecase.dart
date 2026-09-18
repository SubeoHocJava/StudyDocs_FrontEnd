import '../repositories/my_qr_repository.dart';

class GetMyQRUseCase {
  final MyQRRepository repository;

  GetMyQRUseCase(this.repository);

  Future<String> execute(String userId) {
    return repository.getMyQRData(userId);
  }
}
