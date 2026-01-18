// lib/features/auth/presentation/widgets/login_form.dart
import 'package:flutter/material.dart';
import 'username_field.dart';
import 'password_field.dart';
import 'login_button.dart';
import 'google_login_button.dart';
import 'forgot_password_link.dart';
import 'register_link.dart';
import 'divider_with_text.dart';

/// Form đăng nhập chỉ chịu trách nhiệm:
/// - Quản lý và validate dữ liệu form (email, mật khẩu)
/// - Gọi callback [onSubmit] khi form hợp lệ
///
/// Lưu ý: Form **không** tự xử lý đăng nhập (call API, BLoC, điều hướng, snackbar...)
/// Việc đó sẽ do tầng trên (LoginModal / BLoC) quyết định.
class LoginForm extends StatefulWidget {
  final VoidCallback onForgotPassword;
  final VoidCallback onShowRegister;
  final VoidCallback onGoogleLogin;

  /// Cho phép disable nút và show loading khi đang submit.
  final bool isSubmitting;

  /// Callback được gọi khi người dùng bấm "Đăng nhập" và form validate thành công.
  /// Dùng để đẩy dữ liệu ra ngoài cho BLoC / logic xử lý.
  final void Function(String username, String password) onSubmit;

  const LoginForm({
    super.key,
    required this.onForgotPassword,
    required this.onShowRegister,
    required this.onSubmit,
    required this.onGoogleLogin,
    this.isSubmitting = false,
  });

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Trường nhập username
          UsernameField(controller: _usernameController),

          const SizedBox(height: 16),

          // Trường nhập mật khẩu + link "Quên mật khẩu"
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PasswordField(controller: _passwordController),
              const SizedBox(height: 8),
              ForgotPasswordLink(onTap: widget.onForgotPassword),
            ],
          ),

          const SizedBox(height: 24),

          // Nút "Đăng nhập"
          LoginButton(
            onPressed: widget.isSubmitting ? null : _handleLogin,
            isLoading: widget.isSubmitting,
            label: 'Đăng nhập',
          ),

          const SizedBox(height: 16),

          // Link chuyển sang màn hình đăng ký
          RegisterLink(onTap: widget.onShowRegister),

          const SizedBox(height: 24),

          // Divider với text "hoặc"
          const DividerWithText(text: 'hoặc'),

          const SizedBox(height: 24),

          // Nút đăng nhập bằng Google
          GoogleLoginButton(
            //gọi BloC
            onPressed: widget.onGoogleLogin,
          ),
        ],
      ),
    );
  }

  /// Validate form và đẩy dữ liệu email/password ra ngoài qua [widget.onSubmit].
  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _usernameController.text.trim(),
        _passwordController.text,
      );
    }
  }
}
