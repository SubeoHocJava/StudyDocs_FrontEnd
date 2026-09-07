import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/primary_text_field.dart';
import '../../../../core/widgets/social_button.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'package:studydocs/core/constants/app_colors.dart';

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
      context.read<AuthCubit>().login(
            username: _usernameController.text,
            password: _passwordController.text,
          );
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
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthAuthenticated ||
          current is AuthFailure ||
          current is AuthGooglePending,
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng nhập thành công')),
          );
        } else if (state is AuthGooglePending) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Hoàn tất đăng nhập Google trên trình duyệt, '
                'sau đó quay lại app.',
              ),
            ),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

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
                  color: AppColors.customColor17,
                ),
              ),
              const SizedBox(height: 24),
              PrimaryTextField(
                label: 'Tên đăng nhập',
                hintText: 'Nhập tên đăng nhập',
                controller: _usernameController,
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Vui lòng nhập tên đăng nhập'
                        : null,
              ),
              const SizedBox(height: 16),
              PrimaryTextField(
                label: 'Mật khẩu',
                hintText: 'Nhập mật khẩu',
                obscureText: true,
                controller: _passwordController,
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Vui lòng nhập mật khẩu'
                        : null,
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: isLoading ? null : () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Quên mật khẩu',
                    style: TextStyle(
                      color: AppColors.customColor17,
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
                isLoading: isLoading,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Bạn chưa có tài khoản? ',
                    style: TextStyle(fontSize: 13, color: AppColors.customColor5),
                  ),
                  GestureDetector(
                    onTap: isLoading ? null : widget.onSwitchToRegister,
                    child: const Text(
                      'Tạo tài khoản tại đây',
                      style: TextStyle(
                        color: AppColors.customColor17,
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
                    Expanded(child: Divider(color: AppColors.customColor8)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'hoặc',
                        style: TextStyle(color: AppColors.customColor1, fontSize: 13),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.customColor8)),
                  ],
                ),
              ),
              SocialButton(
                text: 'Đăng nhập bằng Google',
                icon: Image.asset(
                  'assets/images/google.png',
                  width: 24,
                  height: 24,
                ),
                onPressed:
                    isLoading
                        ? () {}
                        : () => context.read<AuthCubit>().loginWithGoogle(),
              ),
            ],
          ),
        );
      },
    );
  }
}
