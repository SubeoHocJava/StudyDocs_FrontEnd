import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/primary_text_field.dart';
import '../cubit/update_email_cubit.dart';
import '../cubit/update_email_state.dart';

class UpdateEmailRequestForm extends StatefulWidget {
  final VoidCallback onCancel;
  final Function(String email) onEmailSubmitted;

  const UpdateEmailRequestForm({
    super.key,
    required this.onCancel,
    required this.onEmailSubmitted,
  });

  @override
  State<UpdateEmailRequestForm> createState() => _UpdateEmailRequestFormState();
}

class _UpdateEmailRequestFormState extends State<UpdateEmailRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<UpdateEmailCubit>().requestUpdateEmail(_emailController.text);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateEmailCubit, UpdateEmailState>(
      listener: (context, state) {
        if (state is UpdateEmailRequestSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mã xác nhận đã được gửi đến email mới', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.green,
            ),
          );
          widget.onEmailSubmitted(state.email);
        } else if (state is UpdateEmailFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is UpdateEmailLoading;

        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Cập nhật Email',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.customColor17,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Nhập địa chỉ email mới để liên kết',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.customColor5),
              ),
              const SizedBox(height: 24),
              PrimaryTextField(
                label: 'Email',
                hintText: 'Nhập email mới',
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Gửi mã xác nhận',
                onPressed: _submit,
                isLoading: isLoading,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: isLoading ? null : widget.onCancel,
                child: const Text('Hủy', style: TextStyle(color: AppColors.customColor17)),
              ),
            ],
          ),
        );
      },
    );
  }
}
