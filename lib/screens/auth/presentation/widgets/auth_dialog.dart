import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';


import 'login_form.dart';
import 'register_form.dart';
import 'forgot_password_email_form.dart';
import 'forgot_password_token_form.dart';
import 'forgot_password_reset_form.dart';

enum AuthDialogMode {
  login,
  register,
  forgotPasswordEmail,
  forgotPasswordToken,
  forgotPasswordReset,
}

class AuthDialog extends StatefulWidget {
  final AuthDialogMode initialMode;

  const AuthDialog({super.key, this.initialMode = AuthDialogMode.login});

  @override
  State<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  late AuthDialogMode _mode;
  
  // Shared state for forgot password flow
  String _forgotEmail = '';
  String _forgotToken = '';

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
  }

  void _switchMode(AuthDialogMode newMode) {
    setState(() {
      _mode = newMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_mode) {
      case AuthDialogMode.login:
        return SingleChildScrollView(
          key: const ValueKey('login'),
          child: LoginForm(
            onSwitchToRegister: () => _switchMode(AuthDialogMode.register),
            onSwitchToForgotPassword: () => _switchMode(AuthDialogMode.forgotPasswordEmail),
          ),
        );
      case AuthDialogMode.register:
        return SingleChildScrollView(
          key: const ValueKey('register'),
          child: RegisterForm(
            onSwitchToLogin: () => _switchMode(AuthDialogMode.login),
          ),
        );
      case AuthDialogMode.forgotPasswordEmail:
        return SingleChildScrollView(
          key: const ValueKey('forgot_email'),
          child: ForgotPasswordEmailForm(
            onBackToLogin: () => _switchMode(AuthDialogMode.login),
            onEmailSubmitted: (email) {
              _forgotEmail = email;
              _switchMode(AuthDialogMode.forgotPasswordToken);
            },
          ),
        );
      case AuthDialogMode.forgotPasswordToken:
        return SingleChildScrollView(
          key: const ValueKey('forgot_token'),
          child: ForgotPasswordTokenForm(
            email: _forgotEmail,
            onBackToLogin: () => _switchMode(AuthDialogMode.login),
            onTokenVerified: (token) {
              _forgotToken = token;
              _switchMode(AuthDialogMode.forgotPasswordReset);
            },
          ),
        );
      case AuthDialogMode.forgotPasswordReset:
        return SingleChildScrollView(
          key: const ValueKey('forgot_reset'),
          child: ForgotPasswordResetForm(
            email: _forgotEmail,
            token: _forgotToken,
            onResetSuccess: () => _switchMode(AuthDialogMode.login),
          ),
        );
    }
  }
}

void showAuthDialog(BuildContext context, {AuthDialogMode initialMode = AuthDialogMode.login}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'AuthDialog',
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      return AuthDialog(initialMode: initialMode);
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
