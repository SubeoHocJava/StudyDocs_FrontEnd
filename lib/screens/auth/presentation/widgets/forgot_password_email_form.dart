import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/screens/auth/data/auth_service.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/primary_text_field.dart';

class ForgotPasswordEmailForm extends StatefulWidget {
  final VoidCallback onBackToLogin;
  final Function(String email) onEmailSubmitted;

  const ForgotPasswordEmailForm({
    super.key,
    required this.onBackToLogin,
    required this.onEmailSubmitted,
  });

  @override
  State<ForgotPasswordEmailForm> createState() => _ForgotPasswordEmailFormState();
}

class _ForgotPasswordEmailFormState extends State<ForgotPasswordEmailForm> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMsg;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    try {
      final email = _emailController.text.trim();
      await AuthService().forgotPassword(email);
      widget.onEmailSubmitted(email);
    } catch (e) {
      setState(() {
        _errorMsg = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Quên mật khẩu',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.customColor17,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Nhập email của bạn để nhận mã khôi phục.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.gray, fontSize: 14),
          ),
          const SizedBox(height: 24),
          PrimaryTextField(
            label: 'Email',
            hintText: 'Nhập địa chỉ email',
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Vui lòng nhập email';
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Email không hợp lệ';
              }
              return null;
            },
          ),
          if (_errorMsg != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_errorMsg!, style: const TextStyle(color: Colors.red)),
            ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Tiếp tục',
            onPressed: _submit,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: _isLoading ? null : widget.onBackToLogin,
            child: const Text('Quay lại Đăng nhập'),
          ),
        ],
      ),
    );
  }
}
