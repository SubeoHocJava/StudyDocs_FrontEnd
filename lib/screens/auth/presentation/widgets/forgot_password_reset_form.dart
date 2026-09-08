import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/screens/auth/data/auth_service.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/primary_text_field.dart';

class ForgotPasswordResetForm extends StatefulWidget {
  final String email;
  final String token;
  final VoidCallback onResetSuccess;

  const ForgotPasswordResetForm({
    super.key,
    required this.email,
    required this.token,
    required this.onResetSuccess,
  });

  @override
  State<ForgotPasswordResetForm> createState() => _ForgotPasswordResetFormState();
}

class _ForgotPasswordResetFormState extends State<ForgotPasswordResetForm> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMsg;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    try {
      final password = _passwordController.text;
      await AuthService().resetPassword(widget.email, widget.token, password);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đổi mật khẩu thành công! Vui lòng đăng nhập lại.')),
        );
      }
      widget.onResetSuccess();
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
            'Mật khẩu mới',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.customColor17,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Vui lòng nhập mật khẩu mới của bạn.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.gray, fontSize: 14),
          ),
          const SizedBox(height: 24),
          PrimaryTextField(
            label: 'Mật khẩu mới',
            hintText: 'Nhập mật khẩu mới',
            obscureText: true,
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Vui lòng nhập mật khẩu mới';
              if (value.length < 6) return 'Mật khẩu phải từ 6 ký tự';
              return null;
            },
          ),
          const SizedBox(height: 16),
          PrimaryTextField(
            label: 'Xác nhận mật khẩu',
            hintText: 'Nhập lại mật khẩu mới',
            obscureText: true,
            controller: _confirmController,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Vui lòng xác nhận mật khẩu';
              if (value != _passwordController.text) return 'Mật khẩu không khớp';
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
            text: 'Hoàn tất',
            onPressed: _submit,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
