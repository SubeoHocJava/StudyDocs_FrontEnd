import 'package:flutter/material.dart';
import 'login_form.dart';
import 'register_form.dart';

class AuthDialog extends StatefulWidget {
  const AuthDialog({super.key});

  @override
  State<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  bool _isLogin = true;

  void _switchToRegister() {
    setState(() {
      _isLogin = false;
    });
  }

  void _switchToLogin() {
    setState(() {
      _isLogin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24), // Cách viền 2 bên rộng hơn chút
      child: Container(
        width: 400, // Cố định chiều rộng tối đa (cho tablet/web), trên mobile sẽ bị bóp theo insetPadding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24), // Bo góc mềm mại hơn theo thiết kế
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isLogin
                ? SingleChildScrollView(
                    key: const ValueKey('login'),
                    child: LoginForm(onSwitchToRegister: _switchToRegister),
                  )
                : SingleChildScrollView(
                    key: const ValueKey('register'),
                    child: RegisterForm(onSwitchToLogin: _switchToLogin),
                  ),
          ),
        ),
      ),
    );
  }
}

void showAuthDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'AuthDialog',
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const AuthDialog();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child, // Could wrap with BackdropFilter for blur effect
      );
    },
  );
}
