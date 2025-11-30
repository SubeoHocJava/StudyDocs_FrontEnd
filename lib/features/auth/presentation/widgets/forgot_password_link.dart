// lib/features/auth/presentation/widgets/forgot_password_link.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ForgotPasswordLink extends StatelessWidget {
  final VoidCallback onTap;

  const ForgotPasswordLink({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          'Quên mật khẩu',
          style: TextStyle(
            color: AppColors.headerFg,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}