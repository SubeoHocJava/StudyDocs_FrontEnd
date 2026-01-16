import 'package:studydocs/data/datasource/admin_remote_datasource.dart';
import 'package:studydocs/features/admin/domain/repository/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<int> getTotalDocuments() async {
    return await remoteDataSource.getTotalDocuments();
  }
}
