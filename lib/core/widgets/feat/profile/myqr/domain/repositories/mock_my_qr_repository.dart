import 'my_qr_repository.dart';

class MockMyQRRepository implements MyQRRepository {
  @override
  Future<String> getMyQRData(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return 'study_docs_user_$userId';
  }
}
