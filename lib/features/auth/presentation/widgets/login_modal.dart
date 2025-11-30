// lib/features/auth/presentation/widgets/login_modal.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'login_form.dart';
import 'forgot_password_form.dart';
import 'register_form.dart';

enum AuthModalView {
  login,
  forgotPassword,
  register,
}

class LoginModal extends StatefulWidget {
  const LoginModal({super.key});

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  AuthModalView _currentView = AuthModalView.login;

  void _switchView(AuthModalView view) {
    setState(() {
      _currentView = view;
    });
  }

  String get _title {
    switch (_currentView) {
      case AuthModalView.login:
        return 'Đăng nhập tài khoản';
      case AuthModalView.forgotPassword:
        return 'Quên mật khẩu';
      case AuthModalView.register:
        return 'Tạo tài khoản';
    }
  }

  Widget _buildContent() {
    switch (_currentView) {
      case AuthModalView.login:
        return LoginForm(
          onForgotPassword: () => _switchView(AuthModalView.forgotPassword),
          onShowRegister: () => _switchView(AuthModalView.register),
        );
      case AuthModalView.forgotPassword:
        return ForgotPasswordForm(
          onBackToLogin: () => _switchView(AuthModalView.login),
        );
      case AuthModalView.register:
        return RegisterForm(
          onBackToLogin: () => _switchView(AuthModalView.login),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mediaQuery = MediaQuery.of(context);
          final screenWidth = mediaQuery.size.width;
          final isTabletLayout = screenWidth >= 600; // Giữ modal gọn trên màn hình lớn.
          final maxWidth = isTabletLayout ? 480.0 : screenWidth * 0.92;
          final contentPadding = EdgeInsets.symmetric(
            horizontal: isTabletLayout ? 32 : 20,
            vertical: isTabletLayout ? 32 : 24,
          );

          return AnimatedPadding(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: mediaQuery.viewInsets, // Đẩy modal lên khi bàn phím mở trên mobile.
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth,
                ),
                child: Material(
                  color: Colors.white,
                  elevation: 16,
                  borderRadius: BorderRadius.circular(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: contentPadding,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _title,
                              style: TextStyle(
                                fontSize: isTabletLayout ? 22 : 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.headerFg,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            _buildContent(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}