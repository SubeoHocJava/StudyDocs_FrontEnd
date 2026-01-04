// lib/features/auth/presentation/widgets/login_modal.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studydocs/features/auth/presentation/bloc/register_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/login_bloc.dart';
import '../bloc/auth_status_cubit.dart';
import '../screens/google_debug_screen.dart';
import 'login_form.dart';
import 'forgot_password_form.dart';
import 'register_form.dart';

enum AuthModalView { login, forgotPassword, register }

class LoginModal extends StatefulWidget {
  const LoginModal({super.key});

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  AuthModalView _currentView = AuthModalView.login;

  Map<String, dynamic>? _tryDecodeJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;

    try {
      final normalized = base64Url.normalize(parts[1]);
      final jsonStr = utf8.decode(base64Url.decode(normalized));
      final decoded = jsonDecode(jsonStr);
      if (decoded is Map<String, dynamic>) return decoded;
      return null;
    } catch (_) {
      return null;
    }
  }

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

  /// Xây dựng nội dung phần body của dialog tuỳ theo [_currentView].
  /// Ở view đăng nhập:
  /// - Nhận email/password từ [LoginForm]
  /// - Gửi event [LoginSubmitted] vào [LoginBloc]
  /// Ở view đăng ký:
  /// - Nhận name/email/password -> [RegisterBloc]
  Widget _buildContent({
    required BuildContext context,
    required LoginState loginState,
    required RegisterState registerState,
  }) {
    switch (_currentView) {
      case AuthModalView.login:
        return LoginForm(
          onForgotPassword: () => _switchView(AuthModalView.forgotPassword),
          onShowRegister: () => _switchView(AuthModalView.register),
          isSubmitting: loginState is LoginLoading,
          onSubmit: (username, password) {
            // Gửi event đăng nhập vào LoginBloc
            context.read<LoginBloc>().add(
              LoginSubmitted(username: username, password: password),
            );
          },
          //login gooogle
          onGoogleLogin: () {
            context.read<LoginBloc>().add(const GoogleLoginSubmitted());
          },
        );
      case AuthModalView.forgotPassword:
        return ForgotPasswordForm(
          onBackToLogin: () => _switchView(AuthModalView.login),
        );
      case AuthModalView.register:
        return RegisterForm(
          onBackToLogin: () => _switchView(AuthModalView.login),
          isSubmitting: registerState is RegisterLoading,
          onSubmit: (username, email, password) {
            context.read<RegisterBloc>().add(
              RegisterSubmitted(
                username: username,
                email: email,
                password: password,
              ),
            );
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              // CẬP NHẬT AUTH STATE - Quan trọng để Header update UI
              context.read<AuthStatusCubit>().setAuthenticated(state.token);

              final claims = _tryDecodeJwt(state.token);

              // Nếu token là JWT (Google idToken), điều hướng sang màn demo để show rõ dữ liệu.
              // Màn này demo-only và có thể xoá sau này mà không ảnh hưởng kiến trúc core.
              if (claims != null) {
                final nav = Navigator.of(context, rootNavigator: true);
                nav.pop(); // đóng modal
                nav.push(
                  MaterialPageRoute<void>(
                    builder: (_) => GoogleDebugScreen(idToken: state.token),
                  ),
                );
                return;
              }

              // Login thường: đóng modal và show snackbar
              final nav = Navigator.of(context, rootNavigator: true);
              nav.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đăng nhập thành công!'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              setState(() {
                _currentView = AuthModalView.login;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          final loginState = context.watch<LoginBloc>().state;
          final registerState = context.watch<RegisterBloc>().state;
          final isLoading =
              loginState is LoginLoading || registerState is RegisterLoading;

          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final mediaQuery = MediaQuery.of(context);
                final screenWidth = mediaQuery.size.width;
                final isTabletLayout = screenWidth >= 600;
                final maxWidth = isTabletLayout ? 480.0 : screenWidth * 0.92;
                final contentPadding = EdgeInsets.symmetric(
                  horizontal: isTabletLayout ? 32 : 20,
                  vertical: isTabletLayout ? 32 : 24,
                );

                return GestureDetector(  // ← THÊM wrap toàn bộ
                    behavior: HitTestBehavior.translucent,  // ← Cho touch đi qua vùng trong suốt
                    onTap: () => Navigator.of(context).pop(),  // ← Đóng dialog khi tap ra ngoài
                    child: AnimatedPadding(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      padding: mediaQuery.viewInsets,
                      child: Align(
                        alignment: Alignment.center,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          child: GestureDetector(
                            onTap: () {},  // ← Chặn tap vào modal không đóng
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
                                        color: AppColors.headerForeground,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 24),

                                    if (isLoading)
                                      const LinearProgressIndicator(),
                                    if (isLoading) const SizedBox(height: 16),

                                    _buildContent(
                                      context: context,
                                      loginState: loginState,
                                      registerState: registerState,
                                    ),
                                  ],
                                ),
                              ),
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
        },
      ),
    );
  }
}
