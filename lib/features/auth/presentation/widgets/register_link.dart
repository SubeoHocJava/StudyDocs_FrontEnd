// lib/features/auth/presentation/widgets/register_link.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class RegisterLink extends StatelessWidget {
  final VoidCallback onTap;

  const RegisterLink({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          color: AppColors.docSmallText,
          fontSize: 14,
        ),
        children: [
          const TextSpan(text: 'Bạn chưa có tài khoản? '),
          WidgetSpan(
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                'Tạo tài khoản tại đây',
                style: TextStyle(
                  color: AppColors.headerFg,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}