import '../params/login_params.dart';
import '../params/register_params.dart';

/// Repository là nơi định nghĩa các hành vi làm việc với Auth ở tầng domain.
/// UI/BLoC sẽ gọi vào đây, không gọi trực tiếp datasource.
abstract class AuthRepository {
  /// Đăng nhập với username & password, trả về token (hoặc sau này là User).
  Future<String> login({required LoginParams params});

  /// Đăng ký tài khoản mới (username bắt buộc, email có thể để dành cho khôi phục).
  Future<void> register({required RegisterParams params});

  Future<String> loginWithGoogle();
}


