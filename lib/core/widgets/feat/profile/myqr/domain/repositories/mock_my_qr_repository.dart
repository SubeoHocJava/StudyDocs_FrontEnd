
import 'package:studydocs/data/datasource/user_remote_datasource.dart';
import 'package:studydocs/data/datasource/impl/user_remote_datasource_impl.dart';
import 'my_qr_repository.dart';

class MockMyQRRepository implements MyQRRepository {
  final UserRemoteDataSource userDataSource;

  MockMyQRRepository({UserRemoteDataSource? dataSource}) 
      : userDataSource = dataSource ?? UserRemoteDataSourceImpl();

  @override
  Future<String> getMyQRData(String userId) async {
    final user = await userDataSource.getUser();
    return 'study_docs_user_${user.id ?? userId}';
  }
}
