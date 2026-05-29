import 'package:flutter/material.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/primary_text_field.dart';
import '../../../../core/widgets/social_button.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onSwitchToRegister;

  const LoginForm({super.key, required this.onSwitchToRegister});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Dispatch LoginEvent to AuthBloc
      // context.read<AuthBloc>().add(LoginRequestedEvent(...));
      print("Login with: ${_usernameController.text}");
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Đăng nhập tài khoản',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D1B99),
            ),
          ),
          const SizedBox(height: 24),
          PrimaryTextField(
            label: 'Email',
            hintText: 'Nhập email',
            controller: _usernameController,
            validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập email' : null,
          ),
          const SizedBox(height: 16),
          PrimaryTextField(
            label: 'Mật khẩu',
            hintText: 'Nhập mật khẩu',
            obscureText: true,
            controller: _passwordController,
            validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập mật khẩu' : null,
          ),
          const SizedBox(height: 4), // Gần hơn một chút
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Quên mật khẩu',
                style: TextStyle(
                  color: Color(0xFF0D1B99),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            text: 'Đăng nhập',
            onPressed: _submit,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Bạn chưa có tài khoản? ', style: TextStyle(fontSize: 13, color: Color(0xFF1E293B))),
              GestureDetector(
                onTap: widget.onSwitchToRegister,
                child: const Text(
                  'Tạo tài khoản tại đây',
                  style: TextStyle(
                    color: Color(0xFF0D1B99),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('hoặc', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                ),
                Expanded(child: Divider(color: Color(0xFFE2E8F0))),
              ],
            ),
          ),
          SocialButton(
            text: 'Đăng nhập bằng Google',
            icon: Image.asset('assets/images/google.png', width: 24, height: 24),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
