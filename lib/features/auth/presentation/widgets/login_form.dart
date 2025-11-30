// lib/features/auth/presentation/widgets/login_form.dart
import 'package:flutter/material.dart';
import 'email_field.dart';
import 'password_field.dart';
import 'login_button.dart';
import 'google_login_button.dart';
import 'forgot_password_link.dart';
import 'register_link.dart';
import 'divider_with_text.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onForgotPassword;
  final VoidCallback onShowRegister;

  const LoginForm({
    super.key,
    required this.onForgotPassword,
    required this.onShowRegister,
  });

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email field
          EmailField(controller: _emailController),
          
          const SizedBox(height: 16),
          
          // Password field với forgot password link
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PasswordField(controller: _passwordController),
              const SizedBox(height: 8),
              ForgotPasswordLink(onTap: widget.onForgotPassword),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Login button
          LoginButton(
            onPressed: () => _handleLogin(context),
          ),
          
          const SizedBox(height: 16),
          
          // Register link
          RegisterLink(onTap: widget.onShowRegister),
          
          const SizedBox(height: 24),
          
          // Divider với text "hoặc"
          const DividerWithText(text: 'hoặc'),
          
          const SizedBox(height: 24),
          
          // Google login button
          const GoogleLoginButton(),
        ],
      ),
    );
  }

  void _handleLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // TODO: Xử lý đăng nhập
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      
      // Đóng modal sau khi đăng nhập thành công
      Navigator.of(context).pop();
      
      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng nhập thành công!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}