import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/primary_text_field.dart';
import '../cubit/update_email_cubit.dart';
import '../cubit/update_email_state.dart';

class UpdateEmailVerifyForm extends StatefulWidget {
  final String email;
  final VoidCallback onCancel;
  final VoidCallback onSuccess;

  const UpdateEmailVerifyForm({
    super.key,
    required this.email,
    required this.onCancel,
    required this.onSuccess,
  });

  @override
  State<UpdateEmailVerifyForm> createState() => _UpdateEmailVerifyFormState();
}

class _UpdateEmailVerifyFormState extends State<UpdateEmailVerifyForm> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<UpdateEmailCubit>().verifyAndUpdateEmail(_tokenController.text);
    }
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateEmailCubit, UpdateEmailState>(
      listener: (context, state) {
        if (state is UpdateEmailVerifySuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cập nhật/Liên kết email thành công', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.green,
            ),
          );
          widget.onSuccess();
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
                'Xác nhận Email',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.customColor17,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Mã xác nhận đã được gửi đến\n${widget.email}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppColors.customColor5),
              ),
              const SizedBox(height: 24),
              PrimaryTextField(
                label: 'Mã xác nhận',
                hintText: 'Nhập mã xác nhận',
                controller: _tokenController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Vui lòng nhập mã xác nhận' : null,
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Xác nhận',
                onPressed: _submit,
                isLoading: isLoading,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: isLoading ? null : widget.onCancel,
                child: const Text('Quay lại', style: TextStyle(color: AppColors.customColor17)),
              ),
            ],
          ),
        );
      },
    );
  }
}
