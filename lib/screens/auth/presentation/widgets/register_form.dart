import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/primary_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'package:studydocs/core/constants/app_colors.dart';

class RegisterForm extends StatefulWidget {
  final VoidCallback onSwitchToLogin;

  const RegisterForm({super.key, required this.onSwitchToLogin});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().register(
            username: _usernameController.text,
            password: _passwordController.text,
            fullName: _displayNameController.text,
          );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _displayNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthRegisterSuccess || current is AuthFailure,
      listener: (context, state) {
        if (state is AuthRegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng ký thành công. Vui lòng đăng nhập.')),
          );
          widget.onSwitchToLogin();
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
                'Đăng ký tài khoản',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.customColor17,
                ),
              ),
              const SizedBox(height: 24),
              PrimaryTextField(
                label: 'Tài khoản',
                hintText: 'Nhập tên tài khoản',
                controller: _usernameController,
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Vui lòng nhập tài khoản'
                        : null,
              ),
              const SizedBox(height: 16),
              PrimaryTextField(
                label: 'Tên hiển thị (không bắt buộc)',
                hintText: 'Nhập tên hiển thị',
                controller: _displayNameController,
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
              const SizedBox(height: 16),
              PrimaryTextField(
                label: 'Xác nhận mật khẩu',
                hintText: 'Nhập lại mật khẩu',
                obscureText: true,
                controller: _confirmPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng xác nhận mật khẩu';
                  }
                  if (value != _passwordController.text) {
                    return 'Mật khẩu không khớp';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Đăng ký',
                onPressed: _submit,
                isLoading: isLoading,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Bạn đã có tài khoản? '),
                  GestureDetector(
                    onTap: isLoading ? null : widget.onSwitchToLogin,
                    child: const Text(
                      'Đăng nhập tại đây',
                      style: TextStyle(
                        color: AppColors.customColor17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
