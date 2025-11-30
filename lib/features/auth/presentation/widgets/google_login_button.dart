// lib/features/auth/presentation/widgets/google_login_button.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: () {
          // TODO: Xử lý đăng nhập Google
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Chức năng đăng nhập Google đang được phát triển')),
          );
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.docSmallText),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: AppColors.headerForeground,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Google (có thể thay bằng icon thật)
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.headerForeground,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.g_mobiledata,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Đăng nhập bằng Google',
              style: TextStyle(
                color: AppColors.headerBackground,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}