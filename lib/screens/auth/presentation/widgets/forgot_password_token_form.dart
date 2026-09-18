import 'package:flutter/material.dart';
import 'package:studydocs/core/constants/app_colors.dart';
import 'package:studydocs/screens/auth/data/auth_service.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/primary_text_field.dart';

class ForgotPasswordTokenForm extends StatefulWidget {
  final String email;
  final VoidCallback onBackToLogin;
  final Function(String token) onTokenVerified;

  const ForgotPasswordTokenForm({
    super.key,
    required this.email,
    required this.onBackToLogin,
    required this.onTokenVerified,
  });

  @override
  State<ForgotPasswordTokenForm> createState() => _ForgotPasswordTokenFormState();
}

class _ForgotPasswordTokenFormState extends State<ForgotPasswordTokenForm> {
  final _tokenController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMsg;

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    try {
      final token = _tokenController.text.trim();
      await AuthService().verifyResetToken(widget.email, token);
      widget.onTokenVerified(token);
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
            'Nhập mã xác nhận',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.customColor17,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mã xác nhận đã được gửi đến:\n${widget.email}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.gray, fontSize: 14),
          ),
          const SizedBox(height: 24),
          PrimaryTextField(
            label: 'Mã xác nhận',
            hintText: 'Nhập mã 6 số',
            controller: _tokenController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Vui lòng nhập mã xác nhận';
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
            text: 'Xác nhận',
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
