// lib/features/auth/presentation/widgets/login_button.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  
  const LoginButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.headerFg,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Đăng nhập',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}