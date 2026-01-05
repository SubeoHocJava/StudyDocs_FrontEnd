// lib/features/auth/presentation/widgets/login_button.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;

  const LoginButton({
    super.key,
    required this.onPressed,
    this.label = 'Đăng nhập',
    this.isLoading = false,
  });

  static const double _height = 48;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            AppColors.headerForeground,
          ),
          foregroundColor: WidgetStateProperty.all(
            Colors.white,
          ),
          elevation: WidgetStateProperty.all(0),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.white.withValues(alpha: 0.15);
            }
            return null;
          }),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_height / 2),
            ),
          ),
        ),
        child: isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.headerBackground,
            ),
          ),
        )
            : Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
