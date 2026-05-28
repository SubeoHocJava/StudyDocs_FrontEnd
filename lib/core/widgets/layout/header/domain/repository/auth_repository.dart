import '../../data/auth_remote_data_source.dart';

abstract class AuthRepository {
  // define methods
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSourceHybrid remote;
  AuthRepositoryImpl({required this.remote});
}
