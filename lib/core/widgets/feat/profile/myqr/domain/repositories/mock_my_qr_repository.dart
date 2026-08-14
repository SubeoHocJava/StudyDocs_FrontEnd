
import '../../../../../../../data/datasource/impl/user_datasource_impl.dart';
import '../../../../../../../data/datasource/user_remote_datasource.dart';
import 'my_qr_repository.dart';

class MockMyQRRepository implements MyQRRepository {
  final UserDataSource userDataSource;

  MockMyQRRepository({UserDataSource? dataSource}) 
      : userDataSource = dataSource ?? UserDatasourceImpl();

  @override
  Future<String> getMyQRData(String userId) async {
    final user = await userDataSource.getUser();
    return 'study_docs_user_${user.id ?? userId}';
  }
}
