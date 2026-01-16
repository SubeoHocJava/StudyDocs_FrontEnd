import '../../../../data/model/auth/response/user_me_response.dart';
import '../params/login_params.dart';
import '../params/register_params.dart';

/// Repository là nơi định nghĩa các hành vi làm việc với Auth ở tầng domain.
/// UI/BLoC sẽ gọi vào đây, không gọi trực tiếp datasource.
abstract class AuthRepository {
  /// Đăng nhập với username & password, trả về chi tiết User.
  Future<UserMeResponse> login({required LoginParams params});

  /// Đăng ký tài khoản mới.
  Future<void> register({required RegisterParams params});

  /// Đăng nhập với Google.
  Future<UserMeResponse> loginWithGoogle({String? idToken});
}


