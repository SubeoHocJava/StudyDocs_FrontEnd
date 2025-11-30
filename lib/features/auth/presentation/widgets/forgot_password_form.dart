import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'email_field.dart';
import 'login_button.dart';

class ForgotPasswordForm extends StatefulWidget {
  final VoidCallback onBackToLogin;

  const ForgotPasswordForm({
    super.key,
    required this.onBackToLogin,
  });

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đã gửi hướng dẫn đặt lại mật khẩu tới ${_emailController.text}',
        ),
        backgroundColor: AppColors.headerFg,
      ),
    );

    widget.onBackToLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Nhập email đã đăng ký để nhận hướng dẫn đặt lại mật khẩu.',
            style: TextStyle(
              color: AppColors.docSmallText,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          EmailField(controller: _emailController),
          const SizedBox(height: 24),
          LoginButton(
            onPressed: () => _handleSubmit(context),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: widget.onBackToLogin,
              child: const Text('Quay lại đăng nhập'),
            ),
          ),
        ],
      ),
    );
  }
}

