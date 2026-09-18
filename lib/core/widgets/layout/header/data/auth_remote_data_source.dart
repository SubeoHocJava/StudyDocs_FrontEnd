class DioClient {
  // Mock DioClient constructor
}

abstract class AuthRemoteDataSource {
  // Add backend methods later
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;
  AuthRemoteDataSourceImpl({required this.dioClient});
}

class AuthRemoteDataSourceHybrid implements AuthRemoteDataSource {
  final AuthRemoteDataSourceImpl implementation;
  AuthRemoteDataSourceHybrid({required this.implementation});
}
