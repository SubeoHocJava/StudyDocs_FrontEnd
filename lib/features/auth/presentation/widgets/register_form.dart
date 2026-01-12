import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'email_field.dart';
import 'login_button.dart';
import 'password_field.dart';
import 'username_field.dart';

class RegisterForm extends StatefulWidget {
  final VoidCallback onBackToLogin;

  /// Cho phép disable nút khi đang submit
  final bool isSubmitting;

  /// Callback trả dữ liệu đăng ký ra ngoài (BLoC)
  final void Function(
    String username,
    String? email,
    String password,
    String? displayName,
  ) onSubmit;

  const RegisterForm({
    super.key,
    required this.onBackToLogin,
    required this.onSubmit,
    this.isSubmitting = false,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) return;

    widget.onSubmit(
      _usernameController.text.trim(),
      _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      _passwordController.text,
      _displayNameController.text.trim().isEmpty
          ? null
          : _displayNameController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Tạo tài khoản mới để lưu trữ và đồng bộ tài liệu của bạn.',
            style: TextStyle(
              color: AppColors.docSmallText,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          _buildUsernameField(),
          const SizedBox(height: 16),
          _buildDisplayNameField(),
          const SizedBox(height: 16),
          EmailField(
            controller: _emailController,
            label: 'Email (tuỳ chọn)',
            isRequired: false,
          ),
          const SizedBox(height: 16),
          PasswordField(controller: _passwordController),
          const SizedBox(height: 16),
          _buildConfirmPasswordField(),
          const SizedBox(height: 24),
          LoginButton(
            onPressed: widget.isSubmitting ? null : _handleRegister,
            isLoading: widget.isSubmitting,
            label: 'Tạo tài khoản',
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: widget.onBackToLogin,
              child: const Text('Đã có tài khoản? Đăng nhập'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tên hiển thị (Tuỳ chọn)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.profileName,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _displayNameController,
          decoration: _roundedInputDecoration('Nhập tên hiển thị'),
        ),
      ],
    );
  }

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tên đăng nhập',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.profileName,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _usernameController,
          decoration: _roundedInputDecoration('Nhập tên đăng nhập'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Vui lòng nhập tên đăng nhập';
            }
            if (value.trim().length < 3) {
              return 'Tên đăng nhập phải từ 3 ký tự';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Xác nhận mật khẩu',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.profileName,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: _roundedInputDecoration('Nhập lại mật khẩu'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập lại mật khẩu';
            }
            if (value != _passwordController.text) {
              return 'Mật khẩu không khớp';
            }
            return null;
          },
        ),
      ],
    );
  }

  InputDecoration _roundedInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey[400],
        fontSize: 14,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.headerForeground, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    );
  }
}

